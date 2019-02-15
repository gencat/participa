# KEEP IN MIND WHEN DEPLOYING 0.16

Take a look at the **Upgrade notes** on the [v.0.16 Changelog](https://github.com/decidim/decidim/blob/0.16-stable/CHANGELOG.md), as there are steps, like data migrations, that need to be done in production environment.

- New tasks have been added to `config/shedule.rb`. You need to update the crontab by running `whenever --update-crontab`
