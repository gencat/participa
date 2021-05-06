# frozen_string_literal: true

module Decidim
  module Process
    module Extended
      class ApplicationRecord < ActiveRecord::Base
        self.abstract_class = true
      end
    end
  end
end
