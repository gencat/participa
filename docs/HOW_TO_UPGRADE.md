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
  * Decidim::Type ("decidim-type")
  * Decidim::Process::Extended ("decidim-process-extended")


4. Go to the changelog of the specific branch you are updating. For example, https://github.com/decidim/decidim/blob/master/CHANGELOG.md. And review each of the new developments introduced, and apply the new changes. If there are some new locales added or changed, take in mind, that until the locale :oc is added to the Decidim, you must add the new Occitan translations to the application.

5. also, you can make sure new translations are complete for all languages in your application doing this:
```console
TARGET_BRANCH=master bin/rails decidim:check_locales
```
Be aware that this task might not be able to detect everything, and does not check the new locales added in application, so make sure you also manually check your application before upgrading.

Documentation to this doc:
https://github.com/decidim/decidim/blob/master/docs/getting_started.md#keeping-your-app-up-to-date

Participa has some `config/locales/*_fix.yml` you should try to get rid of the locales that were aded here and are not necessary anymore.
Also, if you need to add locales there, add a comment with the why it was added and when we will be able to remove them.

## WARNING

## Customizations

#### 1. In sign in and sing up views, omniauth buttons are below form

  ##### 	Modified files:

  * `app/views/decidim/devise/registrations/new.html.erb (decidim-core)`
    * Move omniauth buttons render below sign up form.
  * `app/views/decidim/devise/sessions/new.html.erb (decidim-core)`
    * Move omniauth buttons render below sign in form.
  * `app/views/decidim/devise/shared/_omniauth_buttons.html.erb (decidim-core)`
    * Move 'or' separator above social register button.

### Temporal fixes


### Existing modules
These are custom modules and this is what you have to keep in mind when updating the version of Decidim.

  1. Decidim Espais Estables ("decidim-assemblies")
      This module changes "Assembly" translation:
        * CA: "Assemblea" for "Consell de participació"
        * ES: "Asamblea" for "Consejo de participación"

      Modified files are:
      
      * "config/locales/" -> You need to add the new locales added in Decidim, and change the string "Assembly" to the correct translation

#### 2. decidim-home (aka. decidim-core)

  This module, changes some appareance to the home, header and footer of Decidim.

  ##### 	Modified files:

  * `decidim-home/app/views/layouts/decidim/_head.html.erb`
    * Include favicon_link_tag
  * `decidim-home/app/views/layouts/decidim/_language_chooser.html.erb`
    * Full rewrite, basically check for changes on the locales loop
  * `decidim-home/app/views/layouts/decidim/_logo.html.erb`
    * Remove outer link wrapping the logo
    * Custom logo
  * `decidim-home/app/views/layouts/decidim/_main_footer.html.erb`
    * Full rewrite
  * `decidim-home/app/views/layouts/decidim/_wrapper.html.erb`
    * Add class `part-background-gray` to menu
    * Render custom partial `_top_navbar.html.erb`
    * Remove render for partial `topbar_search.html.erb`
    * Add custom link to home page (`.site-title`)
  * `config/locales/`
    * You need to add the new locales added in Decidim.

  ##### 	Custom files:

  * `decidim-home/app/views/layouts/decidim/_top_navbar.html.erb`
    * Implement the a top navbar rendered in `_wrapper.html.erb`
  * `app/cells/decidim/home/content_blocks*`
    * New content block cell for hero slider

  3. Decidim Process Extended ("decidim-participatory-processes")
      This module adds the new fields to the "ParticipatoryProcess": Type, email, and "show_home", so the next files are necessary to overwrite.

      Modified files are:
      * "app/commands/decidim/participatory_processes/admin/copy_participatory_process.rb" -> overwrite decidim file and add new fields in the command.
      * "app/commands/decidim/participatory_processes/admin/create_participatory_process.rb" -> overwrite decidim file and add new fields in the command.
      * "app/commands/decidim/participatory_processes/admin/update_participatory_process.rb" -> overwrite decidim file and add new fields in the command.
      * "app/controllers/decidim/participatory_processes/admin/participatory_processes_controller.rb" -> overwrite decidim file and add default images for hero.
      * "app/controllers/decidim/participatory_processes/participatory_processes_controller.rb" -> overwrite decidim file
      * "app/form/decidim/participatory_processes/admin/participatory_process_form.rb" -> overwrite decidim file and add new fields in the form.
      * "app/views/decidim/participatory_processes/admin/participatory_processes/form.html.erb" -> overwrite decidim file and add new fields in the form.
      * "app/views/decidim/participatory_processes/participatory_processes/show.html.erb" -> overwrite decidim file and add new fields.
      * "config/locales/"-> You need to add the new locales added in Decidim for :oc

  4. Decidim Admin Extended ("decidim-admin"):
    adds the necessary layouts to avoid breaking future features of Decidim with the applied customizations of other modules, like Type.

  5. Decidim Regulations ("decidim-participatory-processes"): This module generates a clone of the Participatory::Process index page and shows those processes that are grouped into a ParticipatoryProcessGroup. The ParticipatoryProcessGroup to show, is created at the backoffice and then the id of this group must be insert in the file: "config/application.rb" with "config.regulation = 3".

      The next files need to be upgraded according to the upgrades of "ParticipatoryProcesses" module. If the files change on participatory processes module, you must also change them on regulations
      * "app/controllers/decidim/participatory_procceses/participatory_processes_controller.rb"
      * "app/controllers/decidim/regulations/"
      * "app/decorators/lib/decidim/filter_form_builder_decorator.rb"
      * "app/views/decidim/participatory_processes/"
      * "app/views/decidim/regulations/"
      * "app/views/layouts/"
      * "config/locales/"

      IMPORTANT: note that some ParticipatoryProcesses classes are already modified in the point 3, and the classes in this module inherits from them, so
      you need to check the changes done in the parent classes.

  6. Also, there are custom files in the application "participa.gencat.cat".

     Modified files are:

      * "app/assets/fonts/" -> Custom fonts added
      * "app/assets/stylesheets/"-> Custom fonts and styles added
      * "app/controllers/decidim/proposals/proposals_controller.rb"-> overwrite decidim file and add the custom * functionality of best-comments
      * "app/controllers/decidim_controller.rb"
      * "app/helpers/decidim/participatory_processes/admin/" -> add helpers for departments, themes, and types
      * "app/views/decidim/proposals/proposals/show.html.erb" -> Change the layout of show proposals adding best comments.
      * "app/views/decidim/proposals/proposals/most_voted_comments.html.erb" -> Add the layout of most voted comments.
      * "app/views/decidim/debates/debats/show.html.erb" -> Change the simple_format method to decidim_sanitize
      * "app/views/layouts/decidim/mailer.html.erb" -> Overwrite the layout of the mailer
      * "config/locales/" -> Add custom locales and :oc locales.

### New modules

  1. Decidim Type ("decidim-type"): Adds a CRUD engine to create new Type