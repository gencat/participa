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
      @visited = {}
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
      object_count = 0
      @document.each(only_current: false, only_loaded: false) do |object|
        object_count += 1
        raise LimitExceeded, :too_many_objects if object_count > limit(:max_objects)

        validate_stream_size(object) if object.is_a?(HexaPDF::Stream)
        inspect_value(object)
      end
    end

    def inspect_value(value)
      case value
      when HexaPDF::Dictionary
        inspect_dictionary(value)
      when HexaPDF::PDFArray, Array
        value.each { |child| inspect_value(child) }
      when HexaPDF::Object
        inspect_value(value.value)
      end
    end

    def inspect_dictionary(dictionary)
      key = dictionary.object_id
      return if @visited[key]

      @visited[key] = true
      types = dictionary[:Type]
      inspect_dictionary_features(dictionary, types)
      inspect_open_action(dictionary)
      inspect_action(dictionary, types)
      inspect_annotation(dictionary, types)
      dictionary.value.each_key { |name| inspect_value(dictionary[name]) }
    end

    def inspect_dictionary_features(dictionary, types)
      keys = dictionary.value.keys
      add_reason(:javascript) if keys.intersect?([:JS, :JavaScript])
      add_reason(:field_action) if dictionary.value.has_key?(:AA)
      add_reason(:xfa) if dictionary.value.has_key?(:XFA)
      add_reason(:embedded_file) if keys.intersect?([:EmbeddedFiles, :EF])
      add_reason(:multimedia) if dictionary.value.has_key?(:RichMediaContent)
      add_reason(:embedded_file) if types == :Filespec && dictionary.value.has_key?(:EF)
    end

    def inspect_open_action(dictionary)
      return unless dictionary.value.has_key?(:OpenAction)

      open_action = dictionary[:OpenAction]
      allowed = if open_action.is_a?(HexaPDF::Dictionary)
                  open_action[:S] == :GoTo
                else
                  open_action.is_a?(HexaPDF::PDFArray) || open_action.is_a?(Array) || open_action.is_a?(Symbol)
                end
      add_reason(:open_action) unless allowed
    end

    def inspect_action(dictionary, types)
      unless dictionary.value.has_key?(:S)
        add_reason(:prohibited_action) if types == :Action
        return
      end

      action = dictionary[:S]
      return unless action_dictionary?(action, types)

      add_reason(:prohibited_action) unless ALLOWED_ACTIONS.include?(action)
      validate_action(dictionary) if action == :URI
      add_reason(:prohibited_action) if action == :Named && ALLOWED_NAMED_ACTIONS.exclude?(dictionary[:N])
    end

    def action_dictionary?(action, types)
      types == :Action || (action.is_a?(Symbol) && types != :StructElem)
    end

    def inspect_annotation(dictionary, types)
      return unless types == :Annot

      if MULTIMEDIA_ANNOTATIONS.include?(dictionary[:Subtype])
        add_reason(:multimedia)
      elsif dictionary[:Subtype] == :FileAttachment
        add_reason(:embedded_file)
      end
    end

    def validate_action(action)
      uri = action[:URI]
      normalized = uri.to_s.gsub(/[\x00-\x20\x7f]/, "")
      add_reason(:prohibited_action) unless normalized.match?(%r{\Ahttps?://[^/?#]+(?:[/?#]|\z)}i)
    end

    def add_reason(reason)
      @reasons << reason
    end
  end
end
