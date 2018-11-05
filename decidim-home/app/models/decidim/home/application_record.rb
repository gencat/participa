module Decidim
  module Home
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
