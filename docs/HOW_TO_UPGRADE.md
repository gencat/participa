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

## WARNING

  1. decidim-department-admin module was fixed due to changes in app/controllers/decidim/assemblies/admin/assemblies_controller.rb which has its `organization_assemblies` method renamed to `collection` in decidim v0.21.

  2. decidim-idcat_mobil was fixed due to an error about a duplicated route. The :idcat_mobil omniauth provider was being added manually, causing an error in decidim v0.21. Currently, participa is using the branch 'bugfix/omniauth-idcat-mobil' until it's merged.

## Customizations

  1. In sign in and sing up views, omniauth buttons are below form.

    Modified files are:
    *  app/views/decidim/devise/registrations/new.html.erb: Move omniauth buttons render below sign up form.
    *  app/views/decidim/devise/sessions/new.html.erb: Move omniauth buttons render below sign in form.
    *  app/views/decidim/devise/shared/_omniauth_buttons.html.erb: Move 'or' separator above social register button.


### Temporal fixes

### Existing modules
These are custom modules and this is what you have to keep in mind when updating the version of Decidim.

  1. Decidim Espais Estables ("decidim-assemblies")
      This module changes "Assembly" translation for "Governing council". In catalan, "Assamblea" for "Consell rector". and overwrite the file "highlighted_assemblies".

      Modified files are:
      * "config/locales/" -> You need to add the new locales added in Decidim, and change the string "Assembly" to the "Governing council"


  2. Decidim Home ("decidim-core")
      This module, changes some appareance to the home, header and footer of Decidim.

      Modified files are:
      * "app/views/layouts/" -> overwrite existing decidim layouts, these needs to be upgraded if there are some changes or new functionalities are added.
      * "app/cells/" -> create new cells content_blocks for hero slider.
      * "config/locales/" -> You need to add the new locales added in Decidim.

      Custom files:
      * "cells/" -> Creating the new content_block cell for FEDER.
      * "_main_footer.html.erb" -> Customized footer for Generalitat de Catalunya.

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


### New modules
  1. Decidim Admin Extended ("decidim-admin"):
  adds the necessary layouts to avoid breaking future features of Decidim with the applied customizations of other modules, like Type.

  2. Decidim Type ("decidim-type"): Adds a CRUD engine to create new Type

  3. Decidim Regulations ("decidim-regulations"): This module generates a clone of the Participatory::Process index page and shows those processes that are grouped into a ParticipatoryProcessGroup. The ParticipatoryProcessGroup to show, is created at the backoffice and then the id of this group must be insert in the file: "config/application.rb" with "config.regulation = 3".

      The next files need to be upgraded according to the upgrades of "ParticipatoryProcesses" module. If the files change on participatory processes module, you must also change them on regulations
      * "app/controllers/decidim/participatory_procceses/participatory_processes_controller.rb"
      * "app/controllers/decidim/regulations/"
      * "app/decorators/lib/decidim/filter_form_builder_decorator.rb"
      * "app/views/decidim/participatory_processes/"
      * "app/views/decidim/regulations/"
      * "app/views/layouts/"
      * "config/locales/"
