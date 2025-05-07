# frozen_string_literal: true

namespace :softcatala do
  desc <<~EODESC
    Translate from one locale to another. Params:
    - text: Text to translate
    - source_locale: The locale from which the :text belongs
    - target_locale: The locale to translate to.
  EODESC
  task :translate, [:text, :source_locale, :target_locale] => :environment do |_task, args|
    text= args.text
    source_locale= args.source_locale
    target_locale= args.target_locale
    client= ParticipaGencat::SoftcatalaClient.new

    translated_text= client.translate(text, source_locale, target_locale)

    puts %(SC TRANSLATED: [#{source_locale}] "#{text}" => [#{target_locale}] "#{translated_text}")
  end
end
