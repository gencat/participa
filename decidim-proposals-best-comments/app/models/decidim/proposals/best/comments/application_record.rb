module Decidim
  module Proposals
    module Best
      module Comments
        class ApplicationRecord < ActiveRecord::Base
          self.abstract_class = true
        end
      end
    end
  end
end
