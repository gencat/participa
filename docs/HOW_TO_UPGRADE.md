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
  * Decidim::Department ("decidim-department")
  * Decidim::Theme ("decidim-theme")
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
decidim-department-admin module should be fixed due to changes in app/controllers/decidim/assemblies/admin/assemblies_controller.rb which has its `organization_assemblies` method removed. Probably we should override `collection` instead.

## Customizations

  1. In sign in and sing up views, omniauth buttons are below form.

    Modified files are:
    *  app/views/decidim/devise/registrations/new.html.erb: Move omniauth buttons render below sign up form.
    *  app/views/decidim/devise/sessions/new.html.erb: Move omniauth buttons render below sign in form.
    *  app/views/decidim/devise/shared/_omniauth_buttons.html.erb: Move 'or' separator above social register button.


### Temporal fixes

#### Temporal fix: remove the "(@sobrenom)" from registration nickname help
This fix has already been applied to decidim/decidim:v0.19, but we have a backport for gencat.
When updating to v0.19, remove the keys:
- decidim/devise/omniauth_registrations/new/nickname_help
- decidim/devise/registrations/new/nickname_help

from `config/locales/??_core.yml` files.

#### Temporal fix: proposals originated in meetings
Meetings with associated proposals (e.g. with proposals originated in the meeting) crash to be rendered. This is because of the presenter used.

There is a bugfix in current master (06/11/2019) but this bugfix has a mispelling bug itself: https://github.com/decidim/decidim/pull/5383/commits/35b69c9cb80fba850109ca9fce0edb97b5280856

So, we're overriding the proposalPresenter with the correct fix. When participa is upgraded to Decidim v0.20 with the correct fix, this overrides should be removed (and its directories):

- app/presenters/decidim/proposals/proposal_presenter.rb
- decidim-core/app/cells/decidim/coauthorships_cell.rb

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
      * "_mini_footer.html.erb" -> Standard Decidim footer.

  3. Decidim Process Extended ("decidim-participatory-processes")
      This module adds the new fields to the "ParticipatoryProcess": Theme, Type, Department, email, and "show_home", so the next files are necessary to overwrite.

      Modified files are:
      * "app/commands/decidim/participatory_procces/admin/copy_participatory_process.rb" -> overwrite decidim file and add new fields in the command.
      * "app/commands/decidim/participatory_procces/admin/create_participatory_process.rb"-> overwrite decidim file and add new fields in the command.
      * "app/commands/decidim/participatory_procces/admin/update_participatory_process.rb"-> overwrite decidim file and add new fields in the command.
      * "app/controllers/decidim/participatory_procces/admin/participatory_procces_controller.rb"-> overwrite decidim file and add default images for hero.
      * "app/form/decidim/participatory_procceses/admin/participatory_procces_form.rb"-> overwrite decidim file and add new fields in the form.
      * "app/views/decidim/participatory_procceses/admin/participatory_processes/form.html.erb"-> overwrite decidim file and add new fields in the form.
      * "config/locales/"-> You need to add the new locales added in Decidim for :oc


### New modules
  1. Decidim Admin Extended ("decidim-admin"):
  adds the necessary layouts to avoid breaking future features of Decidim with the applied customizations of other modules, like Department, Theme or Type.

  2. Decidim Type ("decidim-type"): Adds a CRUD engine to create new Type

  3. Decidim Regulations ("decidim-regulations"): This module generates a clone of the Participatory::Process index page and shows those processes that are grouped into a ParticipatoryProcessGroup. The ParticipatoryProcessGroup to show, is created at the backoffice and then the id of this group must be insert in the file: "config/application.rb" with "config.regulation = 3".

      The next files needs to be upgraded according with the upgrades of "ParticipatoryProcesses" module. If the files change to participatory processes module, you must also change them to regulations
      * "app/controllers/decidim/participatory_procceses/participatory_processes_controller.rb"
      * "app/controllers/decidim/regulations/"
      * "app/queries/decidim/participatory_processes/"
      * "app/views/decidim/participatory_process_groups/"
      * "app/views/decidim/participatory_processes/"
      * "app/views/decidim/regulations/"
      * "app/views/layouts/"
      * "config/locales/"
