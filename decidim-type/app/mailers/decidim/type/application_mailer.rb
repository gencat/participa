# frozen_string_literal: true

module Decidim
  module Type
    class ApplicationMailer < ActionMailer::Base
      default from: "from@example.com"
      layout "mailer"
    end
  end
end
