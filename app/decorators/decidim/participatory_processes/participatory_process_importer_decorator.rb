# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::ParticipatoryProcessImporterDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::ParticipatoryProcessImporter.prepend(self)
  end

  def import_folders_and_attachments(attachments)
    return if attachments["files"].nil?

    attachments["files"].each { |file| import_pdf_checked_attachment(file) }
    import_attachment_collections(attachments["attachment_collections"])
  end

  private

  def import_pdf_checked_attachment(file)
    url = file["remote_file_url"]
    return if url.blank?

    error = remote_file_error(url)
    return warn_attachment_import_error(file, error) if error.present?

    Decidim.traceability.perform_action!("create", Decidim::Attachment, @user) do
      attachment = Decidim::Attachment.new(
        title: file["title"],
        description: file["description"],
        attached_to: @imported_process,
        weight: file["weight"]
      )
      attachment.attached_uploader(:file).remote_url = url
      attachment.set_content_type_and_size
      attachment.create_attachment_collection(file["attachment_collection"])
      attachment.save!
      attachment
    end
  rescue ActiveRecord::RecordInvalid => e
    raise unless pdf_security_rejection?(e.record)

    @warnings << I18n.t("pdf_security.import_attachment_error", title: attachment_title(file))
  rescue OpenURI::HTTPError, Errno::ENOENT, Errno::ECONNREFUSED, SocketError, Net::OpenTimeout, Net::ReadTimeout => e
    warn_attachment_import_error(file, format_error(e))
  end

  def warn_attachment_import_error(file, error)
    @warnings << I18n.t(
      "decidim.participatory_processes.admin.imports.attachment_error",
      title: attachment_title(file),
      error:
    )
  end

  def import_attachment_collections(collections)
    return if collections.blank?

    collections.map do |collection|
      Decidim.traceability.perform_action!("create", Decidim::AttachmentCollection, @user) do
        create_attachment_collection(collection)
      end
    end
  end

  def pdf_security_rejection?(record)
    return false unless record.is_a?(Decidim::Attachment)

    record.errors.details.fetch(:file, []).any? do |error|
      [:pdf_prohibited_content, :pdf_uninspectable].include?(error[:error])
    end
  end
end

Decidim::ParticipatoryProcesses::ParticipatoryProcessImporterDecorator.decorate
