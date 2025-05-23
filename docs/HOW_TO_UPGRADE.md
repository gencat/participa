# HOW TO UPGRADE PARTICIPA.GENCAT.CAT

## Steps to follow:
In order to update the application correctly, the points commented in this file must be followed:

Decidim are releasing new versions continuously. In order to get the latest one, update the dependencies:

We recommend upgrading version to version to prevent errors.

### Steps

1. Go to the Gemfile and upgrade the decidim version to the next one stable.

2. Go to the console and run
```console
bundle update decidim
```

3. Make sure you get all the latest migrations:
```console
bin/rails decidim:upgrade
bin/rails railties:install:migrations
bin/rails db:migrate
```

  Custom modules with migrations.
  * Decidim::Process::Extended ("decidim-process-extended")


4. Go to the changelog of the specific branch you are updating. For example, https://github.com/decidim/decidim/blob/main/CHANGELOG.md. And review each of the new developments introduced, and apply the new changes.
   If there are some new locales added or changed, take in mind, that until the locale :oc is added to the Decidim, you must add the new Occitan translations to the application.

5. also, you can make sure new translations are complete for all languages in your application doing this:
```console
TARGET_BRANCH=master bin/rails decidim:check_locales
```
Be aware that this task might not be able to detect everything, and does not check the new locales added in application, so make sure you also manually check your application before upgrading.

Documentation to this doc:
https://github.com/decidim/decidim/blob/master/docs/getting_started.md#keeping-your-app-up-to-date

Participa has some `config/locales/*_fix.yml` you should try to get rid of the locales that were aded here and are not necessary anymore.
Also, if you need to add locales there, add a comment with the why it was added and when we will be able to remove them.

## Customizations

#### 1. In sign in and sing up views, omniauth buttons are below form

  ##### 	Modified files:

  * `app/views/decidim/devise/registrations/new.html.erb (decidim-core)`
    * Move omniauth buttons render below sign up form.
  * `app/views/decidim/devise/sessions/new.html.erb (decidim-core)`
    * Move omniauth buttons render below sign in form.
  * `app/views/decidim/devise/shared/_omniauth_buttons.html.erb (decidim-core)`
    * Move 'or' separator above social register button.

### Existing modules
These are custom modules and this is what you have to keep in mind when updating the version of Decidim.

#### 1. Decidim Espais Estables ("decidim-assemblies")
  This module changes "Assembly" translation:
    * CA: "Assemblea" for "Consell de participació"
    * ES: "Asamblea" for "Consejo de participación"
    * EN: "Assembly" for "Participation council"

  Modified files are:

  * `config/locales/`
    * Copy the locale files from Decidim (decidim-assemblies), and change the string "Assembly" to the correct one

#### 2. decidim-home (aka. decidim-core)

  This module, changes some appareance to the home, header and footer of Decidim.

  ##### 	Modified files:

  * `decidim-home/app/views/layouts/decidim/_head.html.erb`
    * Include favicon_link_tag
  * `decidim-home/overrides/layouts/decidim/header` and override views
    * Add to the top of page a custom navbar for Gencat with language chooser
    * Remove outer link wrapping the logo
    * Custom logo
  * `decidim-home/overrides/layouts/decidim/footer`
    * Add footer FEDER to footers
  * `config/locales/`
    * You need to add the new locales added in Decidim. (TODO: this translations are also in the general files)

#### 3. Decidim Process Extended ("decidim-participatory-processes")

  This module adds new fields to the "ParticipatoryProcess": `email`, `promoting_unit`, `facilitators`, `cost`, `has_summary_record`, `type_id`

  ##### 	Modified files:

  Following overrides have been resolved with corresponding decorator pattern as follows:

  * `decorators/decidim/participatory_processes/admin/copy_participatory_process_decorator.rb`
    * Override to add new fields in the command.
  * `decorators/decidim/participatory_processes/admin/create_participatory_process_decorator.rb`
    * Override to add new fields in the command.
  * `decorators/decidim/participatory_processes/admin/update_participatory_process_decorator.rb`
    * Override to add new fields in the command.
  * `decorators/decidim/participatory_processes/admin/participatory_processes_controller_decorator.rb`
    * Override to add default images for hero.
  * `decorators/decidim/participatory_processes/admin/participatory_process_form_decorator.rb`
    * Override to add new fields in the form.
  * `decorators/decidim/participatory_processes/participatory_processes_controller_decorator.rb`
    * Override to filter by participatory process specific type.
  * `decorators/cells/decidim/content_blocks/participatory_space_metadata_cell_decorator.rb`
    * Override +metadata_valued_items+ to render two non string custom fields.
  * `decorators/cells/decidim/participatory_processes/content_blocks/metadata_cell_decorator.rb`
    * Override +metadata_items+ to add gencat custom fields.
  * `decorators/decidim/participatory_processes/participatory_process_serialize_decorator.rb`
    * Override to add new fields in serializer.

  Following ones, are same new fields in template:
  * `app/views/decidim/participatory_processes/admin/participatory_processes/form.html.erb`
    * Add new field: promoting_unit
    * Add new field: facilitators
    * Add new field: cost
    * Add new field: email
    * Add new field: has_summary_record
  * `config/locales/`
    * Overrides some translations keys (the full oc source is inside the application locales)

#### 5. Decidim Regulations ("decidim-participatory-processes"):

  This module generates a clone of the Participatory::Process index page and shows those processes that are grouped into a ParticipatoryProcessGroup.
  The ParticipatoryProcessGroup to show, is created at the backoffice and then the id of this group must be insert in the file: "config/application.rb" with "config.regulation = 3".

  The next files need to be upgraded according to the upgrades of "ParticipatoryProcesses" module. If the files change on participatory processes module, you must also change them on regulations

  _IMPORTANT:_ note that some ParticipatoryProcesses classes are already modified in the point 3, so check if you need to replicate the changes here.

  ##### 	Modified files:
  * `app/controllers/decidim/regulations/`
  * `app/decorators/lib/decidim/filter_form_builder_decorator.rb`
  * `app/decorators/decidim/participatory_processes/admin/participatory_process_groups_controller_decorator.rb`
  * `app/decorators/decidim/participatory_processes/helpers/participatory_process_helper_decorator.rb`
    * Override participatory_process_cta_path in order to use it via `decidim_participatory_processes`
  * `app/views/decidim/regulations/regulation/_order_by_regulations.html (order_by_processes)`
    * Change the rendered cell
  * `app/views/decidim/regulations/regulation/_promoted_process.html`
    * Access `participatory_process_path` url helper via `decidim_participatory_processes`
  * `app/views/decidim/regulations/regulation/index.html`
    * Add section to show floating help (L:12-14)
    * Change traslations from *_processes to *_regulation
    * Change the render for "order_by_processes" partial
    * Change the render for "filters" partial
  * `app/views/decidim/regulations/regulation/index.js`
    * Change the render for "filters" partial
  * `app/views/decidim/regulations/shared/participatory_space_filters/_filters.html (decidim-core)`
    * Duplicated from the original and changed to be a type select
  * `app/views/decidim/regulations/shared/participatory_space_filters/_filters_small_view.html (decidim-core)`
    * Duplicated from the original and changed the render for "filters" partial
  * `app/views/decidim/regulations/shared/participatory_space_filters/_show.html (decidim-core)`
    * Duplicated from the original and changed the render for "filters" partial (x2)
  * `app/views/layouts/decidim/_process_navigation.html.erb`
    * Add method to check if participatory_space is a regulation one (L:4-9)
    * Take into account if participatory_space is a regulation one to show the name (L:15)
    * Add custom script participatory_space is a regulation one  (L:29-34)
  * `app/views/layouts/decidim/_regulation_header.html.erb (_process_header.html.erb)`
    * We are not sure but seems that we are replacing the `process_navigation` partial with custom code and
      using `participatory_process` instead of `participatory_space`
  * `app/views/layouts/decidim/regulation.html.erb (participatory_process.html.erb)`
    * Any change, only the file name
  * `config/locales/`
    * Translations for `regulations` namespace

  ##### 	Other files:

  Check point 3 for changes on:

  * `decidim-process-extended/app/views/decidim/participatory_processes/*`

#### 6. Also, there are custom files in the application "participa.gencat.cat".

  ##### Modified files:

  With decorator pattern:

  * `decorators/decidim/participatory_processes/permissions_decorator.rb`
    * Override to allow private space users to acces public view

  * `decorators/decidim/participatory_space_context_decorator.rb`
    * Override to allow private space users to acces public view
    * probably removable from Decidim v0.24

  * `decorators/lib/decidim/proposals/proposal_serializer_decorator.rb`
    * Override to export proposal emails and names from authors
    * probably removable from Decidim v0.28 (remember remove test too)

  * `lib/decidim/has_private_users.rb`
    * Override to allow private space users to acces public view
    * Could not use a decorator so the whole class has been copied
    * Only the `#can_participate?(user)` has been modified
    * probably removable from Decidim v0.24

  Following ones, for some addings or template overrides:

  * `app/views/layouts/decidim/mailer.html.erb (decidim-core)`
    * Full rewrite
  * `config/locales/`
    * Overrides some translations keys
    * Fixes some Decidim translations in `*_fix.yml` files

  ##### 	Custom files:

  * `app/assets/fonts/`
    * Added custom font: OpenSans
  * `app/assets/stylesheets/`
    * Custom fonts and styles added
  * `app/controllers/decidim_controller.rb`
    * This controller is needed in all Decidim installations (empty at the moment)
