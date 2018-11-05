module Decidim
  module Proposals
    module Best
      module Comments
        class ApplicationMailer < ActionMailer::Base
          default from: 'from@example.com'
          layout 'mailer'
        end
      end
    end
  end
end
