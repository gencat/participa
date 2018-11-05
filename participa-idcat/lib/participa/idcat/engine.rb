module Participa
  module Idcat
    class Engine < ::Rails::Engine
      isolate_namespace Participa::Idcat

      initializer "participa_idcat.append_routes", before: :load_config_initializers do |app|
        Rails.application.routes.append do
          mount Participa::Idcat::Engine => "/"
        end
      end

      # Añadimos nuestro handler de aurotización a los disponibles
      initializer "participa_idcat.decidim" do |_app|
        Decidim.configure do |config|
          config.authorization_handlers += [IdcatAuthorizationHandler]
        end
      end
    end
  end
end
