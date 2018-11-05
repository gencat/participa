module Decidim
  module Search
    module User
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Search::User
      end
    end
  end
end
