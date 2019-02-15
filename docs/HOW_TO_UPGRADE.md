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

## Customizations

### Existing modules
These are custom modules  and this is what you have to keep in mind when updating the version of Decidim.

  1. Decidim Espais Estables ("decidim-assemblies")
      This module changes "Assembly" translation for "Governing council". In catalan, "Assamblea" for "Consell rector". and overwrite the file "highlighted_assemblies".

      Modified files are:
      * "app/views/decidim/assemblies/pages/home/highlihted_assemblies.html.erb" -> In this file, copy and paste the original file, and limit the number of assemblies to show. (This is necessary to do so until content_blocks are limited to 4 elements.)
      * "config/locales/" -> You need to add the new locales added in Decidim, and change the string "Assembly" to the "Governing council"


  2. Decidim Home ("decidim-core")
      This module, changes some appareance to the home, header and footer of Decidim.

      Modified files are:
      * "app/controllers/decidim/pages_controller.rb" -> overwrite existing file with home_participatory_processes method to show in hero.html.erb
      * "app/views/layouts/" -> overwrite existing decidim layouts, these needs to be upgraded if there are some changes or new functionalities are added.
      * "app/views/pages/home/hero.html.erb" -> overwrite the hero.html.erb with an slider instead of fixed image.
      * "config/locales/" -> You need to add the new locales added in Decidim.

      Custom files:
      * "cells/" -> Creating the new content_block cell for FEDER. 

  3. Decidim Process Extended ("decidim-participatory-processes")
      This module adds the new fields to the "ParticipatoryProcess": Theme, Type, Department, email, and "show_home", so the next files are necessary to overwrite.

      Modified files are:
      * "app/commands/decidim/participatory_procces/admin/copy_participatory_process.rb" -> overwrite decidim file and add new fields in the command.
      * "app/commands/decidim/participatory_procces/admin/create_participatory_process.rb"-> overwrite decidim file and add new fields in the command.
      * "app/commands/decidim/participatory_procces/admin/update_participatory_process.rb"-> overwrite decidim file and add new fields in the command.
      * "app/controllers/decidim/participatory_procces/admin/participatory_procces_controller.rb"-> overwrite decidim file and add default images for hero.
      * "app/form/decidim/participatory_procceses/admin/participatory_procces_form.rb"-> overwrite decidim file and add new fields in the form.
      * "app/views/decidim/participatory_procceses/admin/participatory_processes/form.html.erb"-> overwrite decidim file and add new fields in the form.
      * "app/decidim/participatory_processes/pages/home/highlihted_processes.html.erb"> In this file, copy and paste the original file, and limit the number of assemblies to show. (This is necessary to do so until content_blocks are limited to 4 elements.)
      * "config/locales/"-> You need to add the new locales added in Decidim for :oc


  4. Decidim Admin Search User ("decidim-admin")
      This module adds a search user in admin site in http://participa.gencat.cat/admin/users.

      Modified files are:
      * "app/controllers/decidim/admin/users_controller.rb" -> overwrite decidim file and add new functionality for search.
      * "app/views/decidim/admin/users/index.html.erb" -> overwrite decidim file and add the search form necessary.
      * "config/locales/" -> Add missing locales for search form.


  5. Decidim Selectable News ("decidim-core")
      This module adds a functionallity to specify the participatory process followers to send the newsletter

      Modified files are:
      * "app/commands/decidim/admin/deliver_newsletter.rb"-> overwrite decidim file with the process id selected
      * "app/controllers/decidim/admin/newsletters_controller.rb"-> overwrite decidim file with the necessary methods to select processes
      * "app/jobs/decidim/admin/newsletter_job.rb"-> overwrite decidim file with the modifications
      * "app/views/decidim/admin/newsletters/index.html.erb"-> overwrite decidim file with the process selected.
      * "app/views/decidim/admin/newsletters/show.html.erb"-> overwrite decidim file with the process selected.
      * "app/views/decidim/admin/newsletters/processes_div.html.erb" -> Add file with the div of processes to select.
      * "config/locales/" -> Add missing locales for search form.


  6. Also there, are custom files in the application "participa.gencat.cat".

      Modified files are:
      * "app/assets/fonts/" -> Custom fonts added
      * "app/assets/stylesheets/"-> Custom fonts and styles added
      * "app/controllers/decidim/proposals/proposals_controller.rb"-> overwrite decidim file and add the custom functionality of best-comments
      * "app/controllers/decidim_controller.rb"
      * "app/helpers/decidim/participatory_processes/admin/" -> add helpers for departments, themes, and types
      * "app/views/decidim/assemblies/assemblies/index.html.erb" -> add custom messages for assemblies.
      * "app/views/decidim/assemblies/order_by_assemblies.html.erb" -> custom order by assemblies
      * "app/views/decidim/pages/index.html.erb" -> Change the layout of index pages.
      * "app/views/decidim/proposals/proposals/index.html.erb" -> Change the layout of index proposals adding categories.
      * "app/views/decidim/proposals/proposals/index.js.erb" -> Change the layout of index proposals adding categories.
      * "app/views/decidim/proposals/proposals/show.html.erb" -> Change the layout of show proposals adding best comments.
      * "app/views/decidim/proposals/proposals/most_voted_comments.html.erb" -> Add the layout of most voted comments.
      * "app/views/decidim/debates/debats/show.html.erb" -> Change the simple_format method to decidim_sanitize
      * "app/views/layouts/decidim/mailer.html.erb" -> Overwrite the layout of the mailer
      * "config/locales/" -> Add custom locales and :oc locales.

### New modules
  1. Decidim Admin Extended ("decidim-admin"):
  adds the necessary layouts to avoid breaking future features of Decidim with the applied customizations of other modules, like Department, Theme or Type.

  2. Decidim Department ("decidim-department"): Adds a CRUD engine to create new Departments

  3. Decidim Theme ("decidim-theme"): Adds a CRUD engine to create new Theme

  4. Decidim Type ("decidim-type"): Adds a CRUD engine to create new Type

  5. Decidim Regulations ("decidim-regulations"): This module generates a clone of the Participatory::Process index page and shows those processes that are grouped into a ParticipatoryProcessGroup. The ParticipatoryProcessGroup to show, is created at the backoffice and then the id of this group must be insert in the file: "config/application.rb" with "config.regulation = 3".

      The next files needs to be upgraded according with the upgrades of "ParticipatoryProcesses" module. If the files change to participatory processes module, you must also change them to regulations
      * "app/controllers/decidim/participatory_procceses/participatory_processes_controller.rb"
      * "app/controllers/decidim/regulations/"
      * "app/queries/decidim/participatory_processes/"
      * "app/views/decidim/participatory_process_groups/"
      * "app/views/decidim/participatory_processes/"
      * "app/views/decidim/regulations/"
      * "app/views/layouts/"
      * "config/locales/"


  6. Decidim Meetings Extended ("decidim-meetings"): Adds a new functionality of "Global Agenda".

      The next files needs to be upgraded according with the upgrades of  "Meetings" module. If the files change to "decidim-meetings" module, you must also change them to "decidim-meetings-extended"
      * "app/controllers/decidim/meetings/extended/meetings_extended_controller.rb"
      * "app/views/decidim/meetings/extended/meetings_extended/meetings.html.erb"
      * "app/views/layouts/pages/meetings/"
      * "config/locales/"
