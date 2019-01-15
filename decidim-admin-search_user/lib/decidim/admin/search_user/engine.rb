module Decidim
  module Admin
    module SearchUser
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Admin::SearchUser
      end
    end
  end
end
