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

Participa has some `config/locales/*_fix.yml` you should try to get rid of the locales that were aded here and are not necessary anymore.
Also, if you need to add locales there, add a comment with the why it was added and when we will be able to remove them.

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

#### Temporal fix: added & in case role_name check.

Currently, in the file:
- lib/decidim/participatory_space_resourceable.rb
we have overridden `user_role_config_for` method, in role_name case check.

The reason for this, is that this method is called from `user_role_config` in `Decidim::Admin::UserRolesHelper` file, with second param `role_name` that can be nil as it is called as `role&.role`.
This happens only when logged in user is Departmental Admin type and this can be possible because this module is only available in this repo.
So, to avoid error when role_name passed is nil, we override this param check with a simple `role_name&.to_sym`

In next versions, this issue will be patched in `decidim/decidim`, so this override could be removed:
- lib/decidim/participatory_space_resourceable.rb



#### Temporal fix: format debate's start_time / end_time in debate_form.rb map_model method

Currently, in the file:
- app/forms/decidim/debates/admin/debate_form.rb
we have overrided `def map_model(model)` method to format start_time and end_time fields

The reason for this, is that a wrong format arrived to from_params method on Rectify form
This happened only when after having created a debate with start_time / end_time, we wanted to edit it and change only one date field, this is only start_time or end_time.
In that moment, de form date's validation fields threw an error because the other date field was in wrong format, so form_builder wasn't able to assign to form.

In next versions, this issue will be patched in `decidim/decidim`, so this override could be removed:
- app/forms/decidim/debates/admin/debate_form.rb


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

  4. Also, there are custom files in the application "participa.gencat.cat".

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
