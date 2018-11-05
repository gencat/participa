module Decidim
  module Meetings
    module Extended
      class ApplicationMailer < ActionMailer::Base
        default from: 'from@example.com'
        layout 'mailer'
      end
    end
  end
end
