# Pla de securització dels adjunts PDF

## Objectiu i abast

Reduir el risc de publicar PDF amb contingut actiu a Decidim 0.31, seguint la defensa en profunditat recomanada per OWASP, sense implantar antivirus.

El pla cobreix càrrega, inspecció, publicació, descàrrega i revisió dels PDF existents. No inclou reconstrucció CDR: aquesta modificaria els bytes i podria invalidar signatures digitals.

Referència: [OWASP File Upload Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html).

Arquitectura confirmada segons la informació rebuda: Active Storage Disk local,
Active Storage en mode proxy, Apache2 com a reverse proxy, sense CDN ni
possibilitat d'un origen separat per als fitxers. Producció coincideix amb
Decidim 0.31.8 i Rails 7.2.4 del lockfile. El `Dockerfile` del repositori no
s'utilitza al desplegament; la configuració operativa és externa a aquest
repositori.

## Política de contingut proposada

- Permetre contingut passiu, signatures digitals, camps i anotacions.
- Permetre enllaços externs com a accions URI HTTP/HTTPS; no permetre esquemes executables ni seguir els enllaços durant la validació.
- No permetre multimèdia, fitxers incrustats ni cap altra acció PDF no autoritzada, inclosos JavaScript, OpenAction, AA, Launch, SubmitForm, ImportData, GoToR, Rendition o accions de reproducció.
- Els camps i les anotacions permesos han de ser passius: rebutjar-hi JavaScript o accions associades, i no permetre XFA ni accions de càlcul/validació amb codi.
- No eliminar ni reescriure objectes del PDF. Si es troba contingut prohibit, rebutjar el fitxer i demanar una còpia corregida.
- Acceptar PDF signats conformes sense modificar-ne els bytes. Una signatura digital no és executable, però tampoc prova que el document sigui segur. No verificar confiança jurídica/criptogràfica com a part de la inspecció.
- Rebutjar PDF corruptes, xifrats o no inspeccionables, i fitxers que excedeixin els límits de processament.

## UX i estratègia de validació

Decisió: validació **síncrona** abans de crear o publicar l'adjunt. No s'accepta un PDF per invalidar-lo més tard amb un job.

UX esperada:

1. L'usuari selecciona el document; Active Storage el puja temporalment.
2. En enviar el formulari, es mostra l'estat de validació i s'impedeix
   l'enviament duplicat mentre el servidor inspecciona el blob. En aquest
   interval pot ser llegible per qui conegui la URL signada de proxy; aquest
   accés temporal s'accepta i no es considera encara la publicació de l'adjunt
   a la pàgina pública del procés.
3. El servidor inspecciona el blob abans d'associar-lo
   com a adjunt públic. Si és conforme, desa l'adjunt i només llavors es mostra
   l'èxit.
4. Si conté estructures prohibides, es mostra un error comprensible, es preserven els altres camps del formulari i el PDF no es publica.
5. Si el parser falla o supera el límit de temps/mida, no es publica. Es mostra un missatge de no s'ha pogut validar, amb possibilitat de tornar-ho a provar. No es mostren detalls interns del parser.
6. Els blobs temporals rebutjats o abandonats no s'associen al procés i es
   purguen segons el cicle de vida d'Active Storage; no es garanteix que la URL
   signada deixi de funcionar immediatament.

La inspecció estructural amb parser no hauria de requerir conversió ni reconstrucció, però el cost s'ha de mesurar a la fase 0 amb PDF representatius i casos límit. Fixar un límit de latència i recursos acordat. Si no es pot complir de manera fiable, aturar-se i tornar a acordar el flux; no publicar fitxers mentre una validació asíncrona queda pendent. La validació asíncrona no forma part del flux aprovat actualment.

## Fase 0. Confirmar arquitectura, fluxos i límits

**Estat:** parcialment completada amb informació del propietari del servei i
inspecció del repositori. No s'ha inspeccionat el servidor de producció ni
executat encara cap prova de rendiment.

### Dades confirmades

- Producció coincideix amb Decidim 0.31.8 i Rails 7.2.4 del `Gemfile.lock`.
- Active Storage desa els fitxers a Disk i les URLs de blob es resolen en mode
  proxy. Apache2 actua de reverse proxy.
- No hi ha CDN ni es pot servir els fitxers des d'un origen separat.
- Segons la informació operativa rebuda, Apache2 no fa cache de les rutes
  Active Storage. Cal verificar-ho al VHost durant la implantació, ja que la
  seva configuració és al servidor i no al repositori.
- En el formulari d'adjunts del procés, en substituir el document i seleccionar
  un PDF nou, s'ha observat una petició a `direct_uploads`. Per tant, aquest
  camí utilitza Active Storage direct upload.
- Abans de desar el formulari, la URL signada de proxy ha retornat
  `206 Partial Content` amb `Content-Range: bytes 0-0/...`. Això confirma que
  qui té aquesta URL pot llegir el blob temporal abans que l'adjunt s'hagi
  desat o validat. S'accepta aquest accés temporal: el requisit acordat és que
  el PDF no s'associï ni es publiqui a la pàgina pública del procés abans de
  passar la validació. La URL signada és un bearer secret i no fa el fitxer
  descobrible mitjançant el llistat públic, però qualsevol persona que n'obtingui
  l'URL el pot llegir mentre el blob existeixi.
- La mida màxima efectiva d'adjunt a producció és 10 MB. La mida d'avatar
  (5 MB) és un límit diferent i no s'ha d'aplicar com a límit dels PDF.
- La inspecció ha de ser síncrona i tenir un pressupost màxim de 5 segons.
  Aquest límit s'aplica al temps d'anàlisi després de rebre el fitxer, no al
  temps de càrrega del fitxer per xarxa.
- Els enllaços URI externs admesos són HTTP/HTTPS. La inspecció no els ha de
  seguir ni obrir.
- Política funcional acordada: permetre camps i anotacions passius; rebutjar
  multimèdia, fitxers incrustats i totes les altres accions no permeses.
  No modificar els bytes ni reconstruir PDF.
- El `Dockerfile` del repositori no s'utilitza en el desplegament; la
  configuració operativa d'Apache2 i dels processos es gestiona fora del repo.

### Resultat del rastreig estàtic de vies d'entrada

El codi de Decidim 0.31.8 comparteix el modal `Decidim::UploadModalCell` per a
`form.attachment` i `form.upload`; el camp del modal fa servir
`direct_upload: true` i l'endpoint de pujada directa comprova mida, MIME i
extensió declarats. Aquestes comprovacions no inspeccionen l'estructura interna
del PDF. Les associacions posteriors passen per validacions de formulari/model
de `Decidim::Attachment`, però no s'hi ha identificat cap validació estructural
de PDF.

| Via identificada | Evidència al codi i moment d'associació | Consideració |
|---|---|---|
| Alta/edició/reemplaçament dels adjunts del procés participatiu | Formulari i comandes genèriques d'adjunts d'Admin (`AttachmentForm`, `CreateAttachment`, `UpdateAttachment`); el reemplaçament amb direct upload ja s'ha confirmat manualment. El PDF s'afegeix des de la secció d'adjunts després de crear el procés. | És la via prioritària. `AttachmentUploader` consulta les regles de càrrega de l'organització; això valida tipus permès, no contingut actiu del PDF. Cal provar al navegador l'alta inicial de l'adjunt i el comportament d'error/reemplaçament. |
| Adjunts múltiples de pàgines estàtiques | Personalització local a `app/overrides/decidim/admin/static_pages/_form/attachments.html.erb.deface` i `app/decorators/decidim/admin/{static_pages_form,create_static_page,update_static_page}_decorator.rb`; usa els mètodes compartits `MultipleAttachmentsMethods`. | És una entrada addicional administrada localment; en una actualització, el codi construeix/valida els nous adjunts abans de netejar els anteriors, però cal provar el comportament d'error al formulari. |
| Adjunts d'altres components Decidim i del mòdul `challenges` | El mateix control d'adjunts apareix a propostes, debats, blogs, eleccions, projectes de pressupost, iniciatives, pàgines i solucions. | Són vies d'entrada quan el component corresponent està habilitat i la configuració d'uploads permet PDF. Cal confirmar quins mòduls/components s'utilitzen efectivament a producció. |
| Respostes a qüestionaris amb pregunta de tipus fitxer | `decidim-forms` usa `response_form.upload :add_attachments`; `ResponseQuestionnaire` construeix i valida els adjunts abans de desar-los. | Via pública, no limitada al personal editor. Reutilitza el mecanisme d'upload i el model genèric `Decidim::Attachment`. |
| Importació d'un procés participatiu | `ParticipatoryProcessImportForm` accepta JSON; `ParticipatoryProcessImporter#import_folders_and_attachments` importa cada `remote_file_url` d'imatge o PDF, primer amb una comprovació HTTP HEAD del tipus declarat i després assignant la URL remota a l'uploader abans de desar l'adjunt. | Via separada del direct upload i del formulari d'adjunts. Una comprovació HEAD/MIME no substitueix la inspecció estructural; cal incorporar-la al mateix control abans de publicar l'adjunt importat. |
| Camps tipats d'imatge i documents de verificació | S'han localitzat càrregues de `hero_image`, `avatar`, imatges de contingut i `verification_attachment`; aquests camps fan servir uploaders d'imatge específics. | No són vies genèriques d'adjunts PDF segons els uploaders del codi. La verificació d'identitat és privada i s'ha de mantenir separada de les vies de publicació pública. |

### Resultat estàtic del lliurament de fitxers

- El formulari inicial del procés només carrega `hero_image` (una imatge). Els
  PDF del procés es gestionen després des d'una ruta separada d'adjunts
  (`participatory_process_attachments`), que reutilitza `HasAttachments` i les
  comandes genèriques de creació/actualització. Per tant, no hi ha una càrrega
  inicial de PDF dins del formulari de creació del procés a verificar; la prova
  manual de reemplaçament correspon al flux d'adjunts.
- `Decidim::Attachment#url` retorna una URL signada de blob proxy per a adjunts
  públics. Per als adjunts associats a un espai privat o component privat no
  transparent, retorna una ruta `private_download`, que requereix sessió
  autenticada i autorització de l'usuari.
- Rails Active Storage 7.2.4 documenta que els controladors de blob són
  accessibles públicament per defecte; el controlador proxy serveix el blob i
  admet peticions de rang. Els `signed_id` són bearer tokens permanents en la
  configuració proxy del projecte.
- **Bypass de privacitat via sitemap identificat i corregit al repositori:**
  el codi original afegia `rails_blob_path` per a tots els registres
  `Decidim::Attachment` amb MIME `image/*` o `application/pdf`, sense filtrar
  espais privats ni cridar `Attachment#url`. Una URL proxy publicada al sitemap
  evita el control d'accés de `private_download`. `config/sitemap.rb` ara
  exclou els adjunts per als quals `private_download_required?` és cert i
  carrega prèviament `attached_to`; `spec/lib/sitemap_spec.rb` cobreix
  l'exclusió de PDFs d'un procés privat i d'un component dins d'un procés
  privat. La suite del sitemap ha passat (31 exemples, 0 errors). La correcció
  és local: cal desplegar-la i regenerar el sitemap; qualsevol URL signada ja
  coneguda continua sent accessible mentre el blob existeixi, per la qual cosa
  cal valorar l'actuació sobre sitemaps antics o URLs ja indexades.
- No s'han trobat rutes personalitzades d'Active Storage a `config/routes.rb`;
  Decidim munta el seu engine a `/`. La configuració de proxy Apache2 no és al
  repositori i encara s'ha de comprovar a l'entorn.

El rastreig cobreix el codi de l'aplicació, els punts d'entrada corresponents
de Decidim 0.31.8 i el flux d'adjunts de `challenges`. Les altres gems externes
declarades al `Gemfile` queden fora de l'abast d'aquest inventari. El rastreig
estàtic tampoc no demostra quins components o configuracions de tipus de fitxer
estan habilitats a cada entorn, ni substitueix les proves d'execució dels
fluxos.

### Estat de les comprovacions de la fase 0

L'inventari estàtic del repositori i de Decidim 0.31.8 està fet dins de l'abast
definit; les gems externes del `Gemfile` en queden excloses. També s'ha
identificat que els PDF d'un procés s'afegeixen després de crear-lo, mitjançant
el gestor d'adjunts, i s'ha confirmat manualment el direct upload en un
reemplaçament. L'abast real d'ús a producció/preproducció també s'ha verificat;
les comprovacions encara pendents es detallen a continuació.

#### Abast real d'ús confirmat

Els components habilitats s'han confirmat com a iguals en ambdós entorns segons
la informació operativa rebuda:

| Manifest | Components |
|---|---:|
| `solutions` | 4 |
| `stratified_sortitions` | 2 |
| `sdgs` | 3 |
| `blogs` | 17 |
| `meetings` | 256 |
| `challenges` | 4 |
| `sortitions` | 2 |
| `problems` | 3 |
| `surveys` | 276 |
| `accountability` | 26 |
| `pages` | 604 |
| `debates` | 34 |
| `budgets` | 17 |
| `proposals` | 737 |

La consulta només lectura al dump de producció de 2026-11-10 ha trobat una
organització. La configuració admet `application/pdf` i l'extensió `pdf` tant
per a participants com per a administradors, amb mida màxima per defecte de
**10 MB**. El propietari ha confirmat que preproducció també té el límit de
10 MB. S'ha confirmat que s'utilitzen els adjunts múltiples de pàgines
estàtiques i la importació de processos amb adjunts remots. Aquests fluxos
formen part de l'abast del control PDF.

### Comprovacions pendents

1. **Completar les proves funcionals dels fluxos d'entrada:** a l'entorn de
   prova, afegir per primera vegada un PDF a un procés i reemplaçar-ne un
   d'existent; verificar també el resultat d'una càrrega fallida. Confirmar que
   l'adjunt nou només s'associa/publica després del submit i que un
   reemplaçament rebutjat conserva l'adjunt anterior. El direct upload i la
   lectura temporal del blob signat abans del submit ja s'han observat en un
   reemplaçament; aquest accés temporal s'accepta i no cal repetir-lo.
2. **Completar la mitigació operativa del sitemap:** desplegar la correcció
   local i regenerar el sitemap; comprovar que conserva adjunts públics i
   exclou adjunts de processos privats. Revisar sitemaps antics i determinar
   si les URLs proxy ja indexades requereixen actuació. La prova automatitzada
   local ja verifica l'exclusió d'un PDF privat.
3. **Verificar a l'entorn operatiu** el VHost d'Apache2: absència de cache a
   les rutes Active Storage, límit del cos de petició compatible amb 10 MB més
   el multipart i timeouts del proxy compatibles amb càrrega i validació. La
   configuració és fora del repositori; no modificar-la sense identificar el
   fitxer i el procés de desplegament.
4. **Avaluar el parser** abans d'escollir-lo. `hexapdf` 1.1.1 consta al
   `Gemfile.lock` com a dependència transitiva, però no se n'ha trobat ús a
   l'aplicació: verificar l'API i demostrar la detecció d'accions prohibides,
   JavaScript en camps/anotacions, fitxers incrustats, multimèdia, estructures
   indirectes, fluxos comprimits i revisions incrementals. No confiar en
   expressions regulars ni en MIME/extensió.
5. **Mesurar rendiment i robustesa** amb PDFs representatius de fins a 10 MB,
   PDF signats conformes, exemples controlats de cada estructura prohibida i
   documents corruptes, xifrats o de complexitat elevada. Mesurar temps
   d'inspecció, CPU i memòria; confirmar que els casos límit compleixen el
   pressupost síncron de 5 segons i els límits de recursos acordats. Si no es
   compleixen, aturar-se i revisar la decisió de latència/UX; no acceptar ni
   publicar el fitxer abans de validar-lo.

### Artefactes a consultar

- `Gemfile.lock` i codi de Decidim 0.31.8 per versions i dependències.
- `config/storage.yml`, `config/routes.rb` i
  `config/initializers/active_storage.rb`.
- `app/decorators/decidim/asset_router/storage_decorator.rb`.
- Formularis, commands i personalitzacions d'adjunts de l'aplicació; també
  fluxos genèrics d'upload de Decidim i importadors.
- Configuració del VHost Apache2, límits i gestió de processos al servidor
  (fora del repositori).
- `docs/decorators_and_overrides.md` per documentar les decisions finals.

### Criteris per donar per tancada la fase

- Matriu d'entrades i sortides completa, inclosos direct uploads, blobs
  temporals i accés per URLs signades.
- Flux inicial i de substitució del procés distingits i documentats. En la
  substitució ja s'ha observat `direct_uploads` i una resposta `206` amb rang
  d'un byte abans del submit; aquest accés temporal s'accepta. Les altres vies
  queden identificades o marcades com a no aplicables amb evidència.
- Límits de càrrega i configuració de proxy verificats a producció/preproducció.
- Parser triat només després de demostrar que aplica la política acordada i
  preserva byte per byte els PDF conformes signats.
- Rendiment mesurat dins del pressupost síncron de 5 segons, amb límits de mida
  (10 MB), CPU, memòria i complexitat documentats.
- Cap afirmació de verificació de producció basada únicament en el lockfile o
  en la configuració del repositori.

## Fase 1. Reduir l'exposició a la descàrrega

**Prerequisits:** traçar les rutes de la fase 0.

Accions:

1. Treure `application/pdf` de `content_types_allowed_inline` d'Active Storage, mantenint el comportament dels altres tipus.
2. Forçar `Content-Disposition: attachment` al servidor, no només a l'enllaç.
3. Verificar MIME i `X-Content-Type-Options: nosniff`.
4. Revisar respostes `200` i `206`, les rutes proxy, les URLs antigues i les capçaleres que Apache2 conserva o modifica.
5. Invalidar la memòria cau d'Apache2, si n'hi ha, després del canvi.

Artefactes:

- `config/initializers/active_storage.rb`.
- `config/initializers/security_headers.rb`, si falta alguna capçalera.
- Configuració real d'Apache2/reverse proxy.
- Nou `spec/requests/pdf_downloads_spec.rb`.
- `spec/lib/active_storage_permanent_urls_spec.rb`.
- `spec/decorators/decidim/asset_router/storage_decorator_spec.rb`.

Acceptació:

- `200`/`206` retornen descàrrega forçada, inclòs si es demana
  `disposition=inline`.
- Altres tipus d'adjunts i imatges continuen funcionant.
- S'explicita que això redueix l'obertura directa, però no elimina el contingut actiu del PDF.

## Fase 2. Inspector estructural i política d'acceptació

**Prerequisits:** parser i límits acordats a la fase 0.

Accions:

1. Revisar extensions, MIME identificat al servidor i mides permeses per a administració i participants. No confiar en l'extensió ni en el MIME declarat pel navegador.
2. Crear un inspector amb resultat explícit: conforme, contingut prohibit o no inspeccionable; retornar motius aptes per a errors d'usuari.
3. Detectar les estructures prohibides de la política, també dins objectes indirectes, fluxos comprimits, anotacions, camps i revisions incrementals.
4. Permetre enllaços URI externs i camps/anotacions passius. Rebutjar les altres accions, multimèdia, fitxers incrustats i codi/accions dins camps/anotacions.
5. Fallar en tancat si el parser troba ambigüitats, errors o excedeix els límits.
6. Inspeccionar els bytes exactes que s'adjuntaran; vincular el resultat a l'empremta SHA-256 per evitar reutilitzar una aprovació després d'un canvi.
7. No modificar els bytes. No reconstruir, netejar ni reescriure PDF.

Artefactes proposats:

- Nou `app/services/pdf_upload_inspector.rb`.
- Integració compartida amb `Decidim::Attachment`; possiblement
  `app/decorators/decidim/attachment_decorator.rb`, després de verificar els punts d'extensió reals.
- `Gemfile`/`Gemfile.lock` només si cal afegir una dependència Ruby.
- Missatges traduïts a `config/locales/`.
- Specs del parser i del servei amb PDFs fixtures controlats.

Acceptació:

- Acceptar un PDF passiu, enllaços externs aprovats, camps/anotacions passius i signatures digitals, preservant byte per byte l'original.
- Rebutjar multimèdia, fitxers incrustats, JavaScript i les altres accions prohibides, també en estructures indirectes/comprimides i revisions antigues.
- Rebutjar documents corruptes/xifrats no inspeccionables i errors/timeout.
- Cap excepció del parser no es tracta com a acceptació.

## Fase 3. Direct upload temporal i validació síncrona

**Prerequisits:** fase 0 i contracte de l'inspector de la fase 2.

Flux proposat per als PDF:

`direct upload temporal -> submit -> inspecció síncrona del blob -> associació/
publicació de l'adjunt o rebuig`

Es manté direct upload. S'accepta que el blob temporal es pugui llegir abans de
la validació per qui conegui la seva URL signada; el requisit és que encara no
estigui associat com a adjunt publicat al procés. La validació ha de passar al
servidor, al submit, abans de crear o actualitzar l'associació pública. Aquesta
distinció és un risc residual: no s'ha d'anomenar el blob "inaccessible" si la
ruta proxy el serveix amb el `signed_id`.

Accions:

1. Mantenir direct upload per obtenir un blob temporal d'Active Storage. En el
   submit, resoldre el `signed_id`, comprovar que el blob correspon a aquesta
   càrrega/usuari i inspeccionar exactament aquests bytes abans d'associar-lo al
   procés. Associar-lo només si la validació síncrona és positiva.
2. No tractar l'acceptació de lectura de la URL temporal com a permís per
   publicar el fitxer: abans d'aprovar-lo no ha d'aparèixer a l'espai públic,
   als llistats d'adjunts, a APIs/serialitzadors, a notificacions ni a índexs.
3. En reemplaçar un document, validar el blob nou abans de canviar l'associació.
   Si es rebutja o falla la validació, mantenir l'adjunt antic publicat i
   descartar/no associar el nou. Aplicar una actualització atòmica perquè no hi
   hagi un interval amb un document no validat publicat.
4. En crear un adjunt nou, no crear l'associació pública ni notificar fins que
   el PDF hagi passat la inspecció.
5. En rebuig, donar feedback específic, mantenir la resta de valors del formulari
   i no desar/publicar el PDF.
6. En error/timeout, retornar un error explícit i recuperable; no generar un
   resultat amb aparença d'èxit.
7. Aplicar el control a substitucions, imports, càrregues múltiples i adjunts
   de pàgines estàtiques. Les importacions han de comunicar el document o fila
   rebutjada, sense saltar la validació.
8. Netejar els temporals abandonats/rebutjats segons la retenció d'Active
   Storage. L'eliminació no és la barrera de publicació i pot no revocar
   immediatament una URL ja coneguda. No enviar notificacions, crear
   previsualitzacions ni indexar abans de l'aprovació.
9. Autoritzar les descàrregues privades segons l'espai participatiu.

Artefactes proposats:

- Formularis/commands i punts d'entrada d'adjunts identificats a la fase 0.
- Integració del `signed_id` als formularis/commands; associar el blob només
  després d'inspeccionar-lo.
- Cicle de vida i neteja dels blobs temporals d'Active Storage Disk.
- `config/locales/` per errors de contingut prohibit/no inspeccionable.
- Specs de càrrega, UX, blob temporal llegible, absència de publicació abans
  de validar, imports i substitucions.

Acceptació:

- Es pot llegir el blob temporal amb la URL signada abans del submit; aquest
  comportament és acceptat i documentat, no una fallada del criteri de publicació.
- Cap PDF no validat queda associat o publicat com a adjunt del procés, ni surt
  als llistats, APIs, notificacions o índexs públics.
- L'adjunt nou només es crea després del resultat conforme; en un reemplaçament
  fallit, l'adjunt vell continua publicat i el nou no queda associat.
- Errors mantenen una UX comprensible i permeten reintentar sense perdre altres
  camps del formulari.
- Cap via de càrrega alternativa evita la inspecció.

## Fase 4. Aïllament i límits del parser

**Prerequisits:** parser triat; obligatòria abans de desplegar les fases 2 i 3.

Accions:

1. Executar el parser sense privilegis i sense secrets de l'aplicació, preferentment en un procés aïllat del servidor web. No hi ha CDR.
2. Desactivar xarxa per defecte; la política no requereix descarregar enllaços per inspeccionar-los.
3. Limitar CPU, memòria, temps, mida, nombre de pàgines i complexitat.
4. Utilitzar noms temporals generats; no passar noms d'usuari a ordres shell. Sanejar el nom que es mostra a la descàrrega.
5. Guardar temporals fora del webroot, restringir permisos i garantir-ne neteja.
6. Fixar versions mantingudes i establir actualitzacions de seguretat.
7. Registrar resultat/codi de motiu sense registrar el contingut del document.
8. Mesurar concurrència i dimensionar el límit de peticions d'upload.

Artefactes:

- Gestió de processos i configuració reals del desplegament, externes al repo.
- Configuració del parser, dependències i monitoratge.
- Procediment operatiu i alertes per errors repetits.

Acceptació:

- Casos límit provats sota recursos limitats.
- El parser no té accés a secrets ni a xarxa interna.
- Error o interrupció deixa el PDF no publicat i els temporals recuperables.

## Fase 5. CSP i capçaleres en el mateix origen

**Prerequisits:** inventari d'integracions de la fase 0. CSP és complementària,
no substitueix la inspecció. No es pot desplegar un origen separat.

Accions:

1. Avaluar `object-src 'none'` i restringir `frame-src` als usos requerits.
2. Revisar gradualment `unsafe-inline` i `unsafe-eval`, mesurant regressions.
3. No assumir que les polítiques addicionals de Decidim eliminen valors permissius de la seva política predeterminada.
4. Verificar CSP i capçaleres a la resposta real del PDF/Active Storage, i que Apache2 no les elimina ni les sobreescriu.
5. No afirmar que CSP bloqueja el JavaScript intern de tots els visors PDF.

Artefactes:

- `config/initializers/decidim.rb`.
- `config/initializers/security_headers.rb`.
- Decorador de CSP només si cal substituir directives predeterminades.
- Configuració d'Apache2/reverse proxy.
- `spec/requests/security_headers_spec.rb` i proves d'integració.

Acceptació:

- Funcionalitats web legítimes continuen funcionant.
- Cap protecció s'atribueix a CSP sense provar la resposta i el visor concrets.

## Fase 6. Revisar PDF existents

**Prerequisits:** inspector, descàrrega forçada i circuit segur operatius.
L'inventari es pot iniciar a la fase 0.

Accions:

1. Inventariar blobs PDF, adjunts, signatures i referències.
2. Inspeccionar en lots limitats, reiniciables i amb registre d'estat.
3. Aprovar documents conformes sense modificar-ne els bytes.
4. Bloquejar els no conformes, notificar responsables i demanar versió corregida.
5. Eliminar accessos residuals per URLs antigues i fitxers temporals Disk.
6. Definir tractament dels documents pendents i conservar evidència mínima segons la política de retenció.

Artefactes:

- Nova tasca `lib/tasks/pdf_security.rake`.
- Registre d'inspecció, emmagatzematge Disk i procediment de comunicació.
- Specs de la tasca i d'invalidació d'accés.

Acceptació:

- Tots els PDF de l'abast tenen resultat traçable.
- Els no conformes no són servits per URLs antigues.
- No es modifica ni retira cap document sense registre i procediment de recuperació.

## Validació transversal i desplegament

Casos de prova mínims:

- PDF passiu; PDF signat conforme acceptat amb bytes idèntics.
- Enllaços externs, camps i anotacions passius permesos.
- JavaScript, OpenAction, AA, Launch, SubmitForm, ImportData, GoToR, multimèdia
  i fitxers incrustats rebutjats, inclosos fluxos comprimits i revisions
  incrementals.
- PDF corrupte, xifrat, massa gran i excessivament complex.
- Error/timeout del parser, substitucions, concurrència i importacions.
- Upload directe: verificar que el blob temporal encara no és adjunt/publicat,
  tot i que la seva URL signada sigui llegible abans del submit.
- Rutes proxy/Disk, descàrregues privades, respostes `200`/`206` i
  `disposition=inline`.
- Regressió d'imatges, altres formats i URLs permanents.

Executar specs focalitzats, mesurar latència/recursos i validar en preproducció
amb Active Storage Disk i Apache2 reals. Registrar les ordres i resultats;
aquest pla no acredita proves executades.

Ordre:

1. Fase 0 i mitigació immediata de la fase 1.
2. Desenvolupar fases 2 i 4; integrar el flux síncron de la fase 3.
3. Provar end-to-end en preproducció i desplegar el circuit complet.
4. Revisar els documents existents (fase 6).
5. Endurir CSP/headers (fase 5) en paral·lel quan sigui viable.

Condició de desplegament: no fer cap PDF accessible abans del resultat síncron
positiu. Davant error o timeout, rebutjar la càrrega explícitament i permetre
reintent; no desactivar silenciosament les comprovacions.

Documentar els canvis a `docs/decorators_and_overrides.md` i `CHANGELOG.md`.
No cal llegir ni modificar `.env` per aquest pla; no incloure secrets als
artefactes ni als logs.
