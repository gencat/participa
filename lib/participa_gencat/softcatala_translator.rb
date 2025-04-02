# frozen_string_literal: true

module ParticipaGencat
  # This translator recieves the field value and the locale of the field
  # which has to be translated.
  # It translates from :source_locale to :target_locale and
  # sends the resulting translation to the MachineTRanslationsSaveJob
  # which must be in charge of persisting it to the model.
  class SoftcatalaTranslator
    attr_reader :text, :source_locale, :target_locale, :resource, :field_name

    def initialize(resource, field_name, text, target_locale, source_locale)
      @resource = resource
      @field_name = field_name
      @text = text
      @target_locale = target_locale
      @source_locale = source_locale
    end

    def translate
      translated_text = softcatala_client.translate(text, source_locale, target_locale)

      ::Decidim::MachineTranslationSaveJob.perform_later(
        resource,
        field_name,
        target_locale,
        translated_text
      )
    end

    #---------------------------------------------------
    private

    #---------------------------------------------------

    def softcatala_client
      @softcatala_client||= SoftcatalaClient.new
    end
  end
end
