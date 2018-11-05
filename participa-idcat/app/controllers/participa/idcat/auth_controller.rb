module Participa
  module Idcat
    class AuthController < Participa::Idcat::ApplicationController
      protect_from_forgery with: :exception
      helper_method :service_params, :auth_url, :error, :idcat_scope

      def index
        #redirect_to auth_url
        auth_url
      end

      def check_token
        # Comprovar que no arribi un error

          # Error:
            # redirect a la plana d'error amb l'error

          # No error: 
            # comprovar el referrer
              # Si no es IDCAT:
                # Submit del token per veure l'autenticació

              # Es IDCAT:
                # Veure si el token es correcte
                  # Ho es:
                    # Autoritzar a l'usuari
                  # No ho es
                    # Redirect a la plana d'error amb l'error
                    #errors.add(:document_number, I18n.t("census_authorization_handler.invalid_document"))
      end

      # Builds a GET URL with the given params (url?param1=value1&...&paramN=valueN)
      def build_url(url, params)
          url = url + "?"
          
          params.each_with_index do |(key, value), index|
            url = url + key + "=" + value
      
            if index != params.size - 1
              url = url + "&"
            end
          end
      
puts params
      
          return url
      end

      def error
        return "error.auth"
      end
      
      def auth_url
        return build_url(service_params["url"], service_params)
      end

      # for use on translations t()
      def idcat_scope
        return "decidim.authorization_handlers.idcat_authorization_handler"
      end

      def service_params

        # Load service config to see which configuration file is active
        serviceConfig = JSON.parse(File.read('participa-idcat/config/environments/config.json'));
        params        = JSON.parse(File.read(serviceConfig['auth_config_file']));

        params['redirect_uri'] = params['redirect_uri'].sub('${base_url}', request.base_url);

        return params
      end
    end
  end
end
