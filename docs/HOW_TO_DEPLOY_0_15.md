# KEEP IN MIND WHEN DEPLOYING 0.15

Take a look to the Changelog https://github.com/decidim/decidim/blob/0.15-stable/CHANGELOG.md to specific actions. Instead of run the "Upgrade notes" on Changelog 0.15, execute next queries to prevent some crashes"

## Notes.
- Comment how the block system of home works. Slider must be activated and FEDER, 0.14
- At 0.15 we can say how many participatory spaces come out in each block of the home. By default they are 4.

- DelayedJOB has been installed, to run metrics. `bin/delayed_job start` must be executed on production
- Whenever has been installed. therefore you must update the crontab by running `whenever --update-crontab`
