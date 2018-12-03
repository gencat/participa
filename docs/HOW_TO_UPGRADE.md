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

4. Go to the changelog of the specific branch you are updating. For example, https://github.com/decidim/decidim/blob/master/CHANGELOG.md. And review each of the new developments introduced, and apply the new changes. If there are some new locales added or changed, take in mind, that until the locale :oc is added to the Decidim, you must add the new Occitan translations to the application.

5. also, you can make sure new translations are complete for all languages in your application doing this:
First, you must define which version of Decidim you are updating by saying the branch in the application.yml, as: `TARGET_BRANCH: "master"`<br/>
Then execute:
```console
bin/rails decidim:check_locales
```
Be aware that this task might not be able to detect everything, and not check the new locales added in application, so make sure you also manually check your application before upgrading.

Documentation to this doc:
https://github.com/decidim/decidim/blob/master/docs/getting_started.md#keeping-your-app-up-to-date

## Customizations

### Existing modules
These are custom modules and that you have to keep in mind when updating the version of Decidim.

  1. Decidim Espais Estables ("decidim-assemblies")
      This module, change the translation to the "Assembly"

      The files modified are:
      * "app/views/decidim/assemblies/pages/home/highlihted_assemblies.html.erb"
      * "config/locales/* "


  2. Decidim Home ("decidim-core")
      This module, change some appareance to the home, header and footer of Decidim.

      The files modified are:
      * "app/controllers/decidim/pages_controller.rb"
      * "app/views/layouts/* "
      * "app/views/pages/home/hero.html.erb"
      * "config/locales/* "


  3. Decidim Process Extended ("decidim-participatory-processes")
      This module add new functionality to the "ParticipatoryProcess"

      The files modified are:
      * "app/views/commands/decidim/participatory_procces/admin/copy_participatory_process.rb"
      * "app/views/commands/decidim/participatory_procces/admin/create_participatory_process.rb"
      * "app/views/commands/decidim/participatory_procces/admin/update_participatory_process.rb"
      * "app/views/controllers/decidim/participatory_procces/admin/participatory_procces_controller.rb"
      * "app/views/form/decidim/participatory_procceses/admin/participatory_procces_form.rb"
      * "app/queries/decidim/participatory_processes/not_regulation.rb"
      * "app/queries/decidim/participatory_processes/organization_published_participatory_processes.rb"
      * "app/views/decidim/participatory_procceses/admin/participatory_processes/form.html.erb"
      * "app/views/decidim/participatory_processes/pages/home/highlihted_processes.html.erb"
      * "config/locales/* "


  4. Decidim Search User ("decidim-admin")
      This module add a search user in admin site.

      The files modified are:
      * "app/controllers/decidim/admin/users_controller.rb"
      * "app/views/decidim/admin/users/index.html.erb"
      * "config/locales/* "


  5. Decidim Selectable News ("decidim-core")
      This module adds a functionallity to specify the participatory process followers to send the newsletter

      The files modified are:
      * "app/commands/decidim/admin/deliver_newsletter.rb"
      * "app/controllers/decidim/admin/newsletters_controller.rb"
      * "app/jobs/decidim/admin/newsletter_job.rb"
      * "app/views/decidim/admin/newsletters/index.html.erb"
      * "app/views/decidim/admin/newsletters/show.html.erb"
      * "app/views/decidim/admin/newsletters/processes_div.html.erb"
      * "config/locales/* "


  6. Also there, are custom files in the participa.

    The files modified are:
    * "app/assets/fonts/* "
    * "app/assets/stylesheets/* "
    * "app/controllers/decidim/proposals/proposals_controller.rb"
    * "app/controllers/decidim_controller.rb"
    * "app/helpers/decidim/participatory_processes/admin/* "
    * "app/views/decidim/assemblies/assemblies/index.html.erb"
    * "app/views/decidim/assemblies/order_by_assemblies.html.erb"
    * "app/views/decidim/pages/index.html.erb"
    * "app/views/decidim/proposals/proposals/index.html.erb"
    * "app/views/decidim/proposals/proposals/index.js.erb"
    * "app/views/decidim/proposals/proposals/show.html.erb"
    * "app/views/decidim/proposals/proposals/most_voted_comments.html.erb"
    * "app/views/layouts/decidim/mailer.html.erb"
    * "config/locales/* "

### New modules
  1. Decidim Admin Extended ("decidim-admin"):
  add the necessary layouts to avoid breaking future features of Decidim with the applied customizations of other modules, like Department, Theme or Type.

  2. Decidim Department ("decidim-department"): Add a CRUD engine to create new Departments

  3. Decidim Theme ("decidim-theme"): Add a CRUD engine to create new Theme

  4. Decidim Type ("decidim-type"): Add a CRUD engine to create new Type

  5. Decidim Regulations ("decidim-regulations"): Group the ParticipatoryProcesses with a ParticipatoryProcessGroup and showed in a clone of index iew of ParticipatoryProcesses called Regulations.

    This needs to be upgraded according with the upgrades of "ParticipatoryProcesses".
    The files to take care are:
    * "app/controllers/decidim/participatory_procceses/participatory_processes_controller.rb"
    * "app/controllers/decidim/regulations/* "
    * "app/queries/decidim/participatory_processes/* "
    * "app/views/decidim/participatory_process_groups/* "
    * "app/views/decidim/participatory_processes/* "
    * "app/views/decidim/regulations/* "
    * "app/views/layouts/* "
    * "config/locales/* "


  6. Decidim Meetings Extended ("decidim-meetings"): Add a new functionality of "Global Agenda".

    This needs to be upgraded according with the upgrades of "Meetings".
    The files to take care are:
    * "app/controllers/decidim/meetings/extended/meetings_extended_controller.rb"
    * "app/views/decidim/meetings/extended/meetings_extended/meetings.html.erb"
    * "app/views/layouts/pages/meetings/* "
    * "config/locales/* "
