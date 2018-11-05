module Decidim
  module Department
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
