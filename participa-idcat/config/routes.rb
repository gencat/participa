Participa::Idcat::Engine.routes.draw do
    # Initial authorization. This will redirect you to IdCAT Mòbil
    get "/idcat/auth", to: "/participa/idcat/auth#index"    

    # This will check if the token generated is valid or not 
    get "/idcat/auth/check_token", to: "/participa/idcat/auth#check_token"

    # This will show an error if the authentication/token failed
    get "/idcat/auth/error", to: "/participa/idcat/auth#error"
end
