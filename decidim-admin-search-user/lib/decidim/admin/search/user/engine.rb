module Decidim
  module Admin
    module Search
      module User
        class Engine < ::Rails::Engine
          isolate_namespace Decidim::Admin::Search::User
        end
      end
    end
  end
end
