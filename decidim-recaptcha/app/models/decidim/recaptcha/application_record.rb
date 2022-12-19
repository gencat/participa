# frozen_string_literal: true

module Decidim
  module Recaptcha
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
