# frozen_string_literal: true

require "csv"
require "json"

namespace :pdf_security do
  desc "Inspect existing PDF attachments without changing them"
  task report: :environment do
    timestamp = Time.current.strftime("%Y%m%d%H%M%S")
    state_path = Rails.root.join("tmp", "pdf_security_report.state")
    saved_state = if File.exist?(state_path)
                    contents = File.read(state_path)
                    begin
                      parsed = JSON.parse(contents)
                      parsed.is_a?(Hash) ? parsed : { "last_id" => contents.to_i, "output" => ENV.fetch("OUTPUT", nil) }
                    rescue JSON::ParserError
                      { "last_id" => contents.to_i, "output" => ENV.fetch("OUTPUT", nil) }
                    end
                  else
                    {}
                  end
    default_output = saved_state["output"] || Rails.root.join("tmp", "pdf_security_report_#{timestamp}.csv").to_s
    output = ENV.fetch("OUTPUT", default_output)
    batch_size = Integer(ENV.fetch("BATCH_SIZE", "100"))
    limit = Integer(ENV.fetch("LIMIT", "0"))
    sleep_seconds = Float(ENV.fetch("SLEEP", "0"))
    default_start_id = saved_state["output"] == output ? saved_state.fetch("last_id", 0).to_i + 1 : 1
    start_id = Integer(ENV.fetch("START_ID", default_start_id.to_s))
    last_id = start_id - 1
    inspected = 0
    counts = Hash.new(0)
    FileUtils.mkdir_p(File.dirname(output))

    CSV.open(output, "a") do |csv|
      if File.empty?(output)
        csv << %w(
          attachment_id blob_id attached_to_type attached_to_id participatory_space
          private byte_size sha256 signed status reasons duration_ms inspected_at
        )
      end

      loop do
        attachments = Decidim::Attachment.unscoped
                                         .joins(:file_attachment)
                                         .includes(file_attachment: :blob)
                                         .where("decidim_attachments.id > ?", last_id)
                                         .order(:id)
                                         .limit(batch_size)
                                         .to_a
        break if attachments.empty?

        attachments.each do |attachment|
          last_id = attachment.id
          blob = attachment.file.blob
          next unless pdf_security_pdf?(blob)

          result = blob.open { |file| PdfSecurity::Inspector.call(file) }
          counts[result.status] += 1
          result.reasons.each { |reason| counts[reason] += 1 }
          csv << [
            attachment.id,
            blob.id,
            attachment.attached_to_type,
            attachment.attached_to_id,
            pdf_security_space_name(attachment.attached_to),
            attachment.private_download_required?,
            blob.byte_size,
            result.sha256,
            result.signed,
            result.status,
            result.reasons.join(";"),
            result.duration_ms,
            Time.current.iso8601
          ].map { |value| pdf_security_csv_value(value) }
          inspected += 1
          break if limit.positive? && inspected >= limit
        end

        csv.flush
        File.write(state_path, JSON.generate(last_id:, output:))
        break if limit.positive? && inspected >= limit

        sleep(sleep_seconds) if sleep_seconds.positive?
      end
    end

    summary = counts.sort.map { |key, count| "#{key}=#{count}" }.join(" ")
    puts "PDF security report: inspected=#{inspected} #{summary}".strip
  end
end

def pdf_security_pdf?(blob)
  declared_pdf = blob.content_type.to_s.split(";", 2).first == "application/pdf" ||
                 blob.filename.extension.to_s.downcase == "pdf"
  return true if declared_pdf

  blob.open { |file| file.read(1024).to_s.include?("%PDF-") }
end

def pdf_security_space_name(resource)
  space = resource.respond_to?(:participatory_space) ? resource.participatory_space : resource
  title = space.respond_to?(:title) ? space.title : nil
  title.is_a?(Hash) ? title.values.find(&:present?).to_s : title.to_s
end

def pdf_security_csv_value(value)
  text = value.to_s
  text.match?(/\A[=+\-@\t\r]/) ? "'#{text}" : text
end
