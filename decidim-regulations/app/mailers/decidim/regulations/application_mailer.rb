# frozen_string_literal: true

module Decidim
  module Regulations
    class ApplicationMailer < ActionMailer::Base
      default from: "from@example.com"
      layout "mailer"
    end
  end
end
