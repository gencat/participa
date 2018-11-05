module Decidim
  module Espais
    module Estables
      class ApplicationMailer < ActionMailer::Base
        default from: 'from@example.com'
        layout 'mailer'
      end
    end
  end
end
