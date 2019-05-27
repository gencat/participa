# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Admin
    module Concerns
      module Administrable
        extend ActiveSupport::Concern

        included do
          def permission_class_chain
            [
              Decidim::Types::Admin::Permissions,
              Decidim::Admin::Permissions
            ]
          end
        end
      end
    end
  end
end
