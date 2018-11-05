# Informació sobre els parámetres de l'autenticació

```
{
    # Endpoint en el que autenticarse.
    # pre: https://identitats-pre.aoc.cat/o/oauth2/auth
    # pro: https://identitats.aoc.cat/o/oauth2/auth
    # dev: http://localhost:8080
    "url": "http://localhost:8080",

    # Identificador de la aplicació web que esta realitzant la operació d’autenticació.
    # Aquest identificador és assignat pel Consorci AOC en el moment de fer
    # el registre de l’aplicació al VALId.
    # Aquests identificadors tenen un aspecte similar al que es mostra a
    # continuació: 0123456789.serveis.aoc.cat
    "client_id": "0123456789.serveis.aoc.cat",

    # URL a la que VALId haurà de retornar el resultat del procés d’autenticació.
    # El resultat de la operació pot ser el codi d’autorització per tal que la
    # aplicació web pugui negociar l’access token definitiu o bé un codi d’error
    # en cas de que la validació no s’hagi pogut realitzar amb èxit.
    # Aquesta URL s’haurà de proporcionar en el moment del registre de l’aplicació.
    # Una aplicació pot tenir més d’una URI de redirecció, però totes han de
    # constar al registre de l’aplicació del VALId.
    "redirect_uri" => "https://172.20.15.90:3000/idcat/check_token",
    
    # Tipus de resposta a retornar. Actualment només es suporta el valor
    # code que indica que el servidor retornarà a la aplicació un codi
    # d’autorització (authorization_code) per a poder negociar el token
    # d’accés.
    "response_type" => "code",
    
    # El paràmetre scope indica una llista de permisos que la aplicació web
    # vol obtenir sobre les dades de l’usuari.
    # Ara per ara, VALId només realitza l’autenticació dels usuaris i no
    # gestiona cap autorització, pel que aquest paràmetre haurà de venir
    # informat sempre amb el valor autenticacio_usuari
    "scope" => "autenticacio_usuari",
    
    # Camp lliure que serà retornat a la aplicació web en el moment de fer-li 
    # arribar el resultat de la autenticació (ja sigui un authorization_code o un error).
    # Donades les restriccions que hi ha en la codificació de les cadenes de
    # text a les URL es recomana usar cadenes molt simples, sense caràcters
    # especials (accentuats, dièresi, etc...) per tal d’evitar problemes en el
    # moment de realitzar les redireccions.
    "state" => "codi_estat_propi",
    
    # Tipus d’accés. Actualment el protocol OAuth 2.0 només admet els
    # valors online i offline. Per a la majoria de casos, s’haurà d’informar el valor online.
    "access_type" => "online",
    
    # Aquest paràmetre indica si cal presentar a l’usuari la pantalla de
    # sol·licitud de permisos que vol obtenir l’aplicació web cada cop o només
    # el primer cop que es realitza la autenticació.
    # Donat que VALId no realitza ara per ara tasques d’autorització, aquest
    # camp no es té en compte, tot i que per especificacions del protocol
    # OAuth és necessari informar-lo.
    "approval_prompt" => "auto"
}
```
