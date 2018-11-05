module Decidim
  module Type
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
