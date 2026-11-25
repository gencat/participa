# frozen_string_literal: true

module PdfSecurity
  class Policy
    class LimitExceeded < StandardError
      attr_reader :reason

      def initialize(reason)
        @reason = reason
        super(reason.to_s)
      end
    end

    ALLOWED_ACTIONS = [:GoTo, :URI, :Named].freeze
    ALLOWED_NAMED_ACTIONS = [:NextPage, :PrevPage, :FirstPage, :LastPage].freeze
    MULTIMEDIA_ANNOTATIONS = [:Movie, :Sound, :Screen, :RichMedia, :"3D"].freeze
    MAX_HEADER_BYTES = 1024

    def initialize(path, limits)
      @path = path
      @limits = limits.transform_keys(&:to_sym)
      @reasons = []
    end

    def inspect
      return result(:uninspectable, :too_large) if File.size(@path) > limit(:max_bytes)
      return result(:uninspectable, :malformed) unless valid_header?

      @document = open_document
      return result(:uninspectable, :encrypted) if @document.encrypted?
      return result(:uninspectable, :too_many_revisions) if @document.revisions.count > limit(:max_revisions)
      return result(:uninspectable, :too_many_pages) if @document.pages.count > limit(:max_pages)

      inspect_objects
      @reasons.uniq!
      result(@reasons.empty? ? :clean : :prohibited, *@reasons)
    rescue LimitExceeded => e
      result(:uninspectable, e.reason)
    rescue HexaPDF::Error, IOError, Zlib::Error
      result(:uninspectable, :malformed)
    rescue StandardError
      result(:uninspectable, :internal_error)
    ensure
      @input&.close
    end

    private

    def result(status, *reasons)
      {
        status: status.to_s,
        reasons: reasons.map(&:to_s),
        signed: @document ? @document.signed? == true : false
      }
    end

    def limit(name)
      @limits.fetch(name)
    end

    def validate_stream_size(stream)
      return unless [:ObjStm, :XRef].include?(stream[:Type])

      decoder = stream.stream_decoder
      decoded_bytes = 0
      loop do
        chunk = decoder.resume
        break if chunk.nil?

        decoded_bytes += chunk.bytesize
        raise LimitExceeded, :stream_too_large if decoded_bytes > limit(:max_stream_bytes)
      end
    end

    def valid_header?
      File.open(@path, "rb") { |file| file.read(MAX_HEADER_BYTES).to_s.include?("%PDF-") }
    end

    def open_document
      @input = File.open(@path, "rb")
      HexaPDF::Document.new(
        io: @input,
        config: {
          "parser.on_correctable_error" => ->(*) { true },
          "parser.try_xref_reconstruction" => false,
          "document.auto_decrypt" => false
        }
      )
    end

    def inspect_objects
      @objects_by_reference = {}
      object_count = 0
      @document.revisions.each do |revision|
        objects = []
        revision.each(only_loaded: false) do |object|
          object_count += 1
          raise LimitExceeded, :too_many_objects if object_count > limit(:max_objects)

          @objects_by_reference[[object.oid, object.gen]] = object
          objects << object
        end
        @visited = {}.compare_by_identity
        objects.each do |object|
          validate_stream_size(object) if object.is_a?(HexaPDF::Stream)
          inspect_value(object)
        end
      end
    end

    def resolve(value)
      if value.is_a?(HexaPDF::Reference)
        value = @objects_by_reference.fetch([value.oid, value.gen]) do
          raise HexaPDF::Error, "Unresolved PDF reference"
        end
      end
      value.is_a?(HexaPDF::Object) ? value.value : value
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def inspect_value(value)
      pending = [[value, :normal]]
      until pending.empty?
        entry, context = pending.pop
        entry = resolve(entry)
        raise HexaPDF::Error, "Invalid PDF action" if context == :action && !entry.is_a?(Hash) && !entry.is_a?(Array)
        next unless entry.is_a?(Hash) || entry.is_a?(Array)

        contexts = (@visited[entry] ||= {})
        next if contexts[context]

        contexts[context] = true
        if entry.is_a?(Array)
          entry.each { |child| pending << [child, context] }
        else
          inspect_dictionary(entry, context, pending)
        end
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def inspect_dictionary(dictionary, context, pending)
      types = resolve(dictionary[:Type])
      inspect_dictionary_features(dictionary, types)
      inspect_open_action(dictionary)
      action_context = context == :action || types == :Action
      inspect_action(dictionary) if action_context
      inspect_annotation(dictionary, types)
      dictionary.each do |name, child|
        pending << [child, child_context(dictionary, types, context, name, child)]
      end
    end

    def child_context(dictionary, types, context, name, child)
      return :action if action_child?(dictionary, types, context, name, child)
      return :outline if name == :Outlines
      return :outline if context == :outline && [:First, :Last, :Next, :Prev].include?(name)

      :normal
    end

    def action_child?(dictionary, types, context, name, child)
      case name
      when :OpenAction then resolve(child).is_a?(Hash)
      when :A then action_owner?(dictionary, types, context)
      when :Next then context == :action || types == :Action
      else false
      end
    end

    def action_owner?(dictionary, types, context)
      types == :Annot || context == :outline || dictionary.has_key?(:FT) ||
        (dictionary.has_key?(:Subtype) && dictionary.has_key?(:Rect))
    end

    def inspect_dictionary_features(dictionary, types)
      keys = dictionary.keys
      add_reason(:javascript) if keys.intersect?([:JS, :JavaScript])
      add_reason(:field_action) if dictionary.has_key?(:AA)
      add_reason(:xfa) if dictionary.has_key?(:XFA)
      add_reason(:embedded_file) if keys.intersect?([:EmbeddedFiles, :EF])
      add_reason(:multimedia) if dictionary.has_key?(:RichMediaContent)
      add_reason(:embedded_file) if types == :Filespec && dictionary.has_key?(:EF)
    end

    def inspect_open_action(dictionary)
      return unless dictionary.has_key?(:OpenAction)

      open_action = resolve(dictionary[:OpenAction])
      allowed = if open_action.is_a?(Hash)
                  resolve(open_action[:S]) == :GoTo
                else
                  open_action.is_a?(Array) || open_action.is_a?(Symbol) || open_action.is_a?(String)
                end
      add_reason(:open_action) unless allowed
    end

    def inspect_action(dictionary)
      action = resolve(dictionary[:S])
      add_reason(:prohibited_action) unless ALLOWED_ACTIONS.include?(action)
      validate_action(dictionary) if action == :URI
      add_reason(:prohibited_action) if action == :Named && ALLOWED_NAMED_ACTIONS.exclude?(resolve(dictionary[:N]))
    end

    def inspect_annotation(dictionary, types)
      return unless types == :Annot

      subtype = resolve(dictionary[:Subtype])
      if MULTIMEDIA_ANNOTATIONS.include?(subtype)
        add_reason(:multimedia)
      elsif subtype == :FileAttachment
        add_reason(:embedded_file)
      end
    end

    def validate_action(action)
      uri = resolve(action[:URI])
      normalized = uri.to_s.gsub(/[\x00-\x20\x7f]/, "")
      add_reason(:prohibited_action) unless normalized.match?(%r{\Ahttps?://[^/?#]+(?:[/?#]|\z)}i)
    end

    def add_reason(reason)
      @reasons << reason
    end
  end
end
