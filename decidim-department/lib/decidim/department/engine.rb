
module Decidim
  module Department
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Department

      initializer "decidim_department.append_routes", before: :load_config_initializers do |app|
        Rails.application.routes.append do
          mount Decidim::Department::Engine => "/"
        end
      end
    end
  end
end
