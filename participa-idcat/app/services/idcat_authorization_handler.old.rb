# frozen_string_literal: true

# An example authorization handler used so that users can be verified against
# third party systems.
#
# You should probably rename this class and file to match your needs.
#
# If you need a custom form to be rendered, you can create a file matching the
# class name named "_form".
#
# Example:
#
#   A handler named Decidim::CensusHandler would look for its partial in:
#   decidim/census/form
#
# When testing your authorization handler, add this line to be sure it has a
# valid public api:
#
#   it_behaves_like "an authorization handler"
#
# See Decidim::AuthorizationHandler for more documentation.
class IdcatAuthorizationHandler < Decidim::AuthorizationHandler
    
      # Define the attributes you need for this authorization handler. Attributes
      # are defined using Virtus.
      #
      # Example:
    
      attribute :redirect, Boolean
    
      # Response params of auth call
      attribute :response_code, String
      attribute :response_state, String
      attribute :response_error, String
    
      # Response params of token call
      attribute :response_access_token, String
      attribute :response_refresh_token, String
      attribute :response_expires_in, String
      attribute :response_token_type, String
    
      # attribute :birthday, Date
      #
      # You can (and should) also define validations on each attribute:
      #
      # validates :document_number, presence: true
      # validate :custom_method_to_validate_an_attribute
      # validates :document_number, presence: true, format: { with: /\A[A-z0-9]*\z/ }
      # validates :mobile, presence: true, format: { with: /\A[0-9]*\z/ }
      #  validates :response_code, presence: true
    
      # The only method that needs to be implemented for an authorization handler.
      # Here you can add your business logic to check if the authorization should
      # be created or not, you should return a Boolean value.
      #
      # Note that if you set some validations and overwrite this method, then the
      # validations will not run, so it's easier to remove this method and rewrite
      # your logic using ActiveModel validations.
      def valid?
        if(true)
         return false
        end
        #raise NotImplementedError
    
        puts "#########################"
        # puts "auth_url: " + auth_url
        # puts "token_url: " + token_url
        # puts "response_code: " + response_code
        # puts "response_state: " + response_state
        puts "#########################"
    
    
        if(!redirect.nil? && redirect)
          puts "redirect_to" + auth_url
          
          # ActionController::Redirecting::redirect_to generate_url("http://172.20.15.90:8080/index.html", :param1 => "foo", :param2 => "bar")
        else
          if(response_code.nil? || response_code.empty?)
            puts "Falta parámetro code"
          elsif(response_state.nil? || response_state.empty?)
            puts "Falta parámetro state"
          else
            puts "TOT CORRECTE!. HAY QUE RECOGER EL TOKEN"
          end
        end
    
        return false
      end
    
      def generate_url(url, params = {})
        uri = URI(url)
        uri.query = params.to_query
        uri.to_s
      end
    
    
      # Builds a call with a url and some params
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
    
      # Common URL params such as the client_id
      def base_url_params
        url_params = {
          # Identificador de la aplicació web que esta realitzant la operació d’autenticació.
          # Aquest identificador és assignat pel Consorci AOC en el moment de fer
          # el registre de l’aplicació al VALId.
          # Aquests identificadors tenen un aspecte similar al que es mostra a
          # continuació: 0123456789.serveis.aoc.cat
          "client_id" => "0123456789.serveis.aoc.cat",
    
          # URL a la que VALId haurà de retornar el resultat del procés d’autenticació.
          # El resultat de la operació pot ser el codi d’autorització per tal que la
          # aplicació web pugui negociar l’access token definitiu o bé un codi d’error
          # en cas de que la validació no s’hagi pogut realitzar amb èxit.
          # Aquesta URL s’haurà de proporcionar en el moment del registre de l’aplicació.
          # Una aplicació pot tenir més d’una URI de redirecció, però totes han de
          # constar al registre de l’aplicació del VALId.
          "redirect_uri" => "https://enotum.aoc.cat/code"
        }
      end
    
      # TODO: esta llamada es vía POST
      # Get he URL to call to do the token authentication
      def token_url
    
        url         = "https://identitats-pre.aoc.cat/o/oauth2/token"
        url_params  = base_url_params
    
        # Codi d’autorització rebut del VALId. Fem servir el code pasat
        url_params["code"] = response_code
    
        # Cadena de text que fa de secret compartit entre la aplicació client i el VALId.
        url_params["client_secret"] = "ABCDE"
    
        # Per especificació OAuth 2.0, el valor d’aquest camp sempre serà authorization_code.on
        url_params["grant_type"] = "authorization_code.on"
        
        return build_url(url, url_params)
      end
    
      # Get he URL toIdcatAuthorizationHandler call to do the authentication
      def auth_url
    
        #url         = "https://identitats-pre.aoc.cat/o/oauth2/auth"
        url         = "http://172.20.15.90:8080/index.html"
        url_params  = base_url_params
    
        # Tipus de resposta a retornar. Actualment només es suporta el valor
        # code que indica que el servidor retornarà a la aplicació un codi
        # d’autorització (authorization_code) per a poder negociar el token
        # d’accés.
        url_params["response_type"] = "code"
        
        # El paràmetre scope indica una llista de permisos que la aplicació web
        # vol obtenir sobre les dades de l’usuari.
        # Ara per ara, VALId només realitza l’autenticació dels usuaris i no
        # gestiona cap autorització, pel que aquest paràmetre haurà de venir
        # informat sempre amb el valor autenticacio_usuari
        url_params["scope"] = "autenticacio_usuari"
        
        # Camp lliure que serà retornat a la aplicació web en el moment de fer-li 
        # arribar el resultat de la autenticació (ja sigui un authorization_code o un error).
        # Donades les restriccions que hi ha en la codificació de les cadenes de
        # text a les URL es recomana usar cadenes molt simples, sense caràcters
        # especials (accentuats, dièresi, etc...) per tal d’evitar problemes en el
        # moment de realitzar les redireccions.
        url_params["state"] = "codi_estat_propi"
        
        # Tipus d’accés. Actualment el protocol OAuth 2.0 només admet els
        # valors online i offline. Per a la majoria de casos, s’haurà d’informar el valor online.
        url_params["access_type"] = "online"
        
        # Aquest paràmetre indica si cal presentar a l’usuari la pantalla de
        # sol·licitud de permisos que vol obtenir l’aplicació web cada cop o només
        # el primer cop que es realitza la autenticació.
        # Donat que VALId no realitza ara per ara tasques d’autorització, aquest
        # camp no es té en compte, tot i que per especificacions del protocol
        # OAuth és necessari informar-lo.
        url_params["approval_prompt"] = "auto"
        
        return build_url(url, url_params)
      end
    
      # If you need to store any of the defined attributes in the authorization you
      # can do it here.
      #
      # You must return a Hash that will be serialized to the authorization when
      # it's created, and available though authorization.metadata
      #
      # def metadata
      #   {}
      # end
    end
    