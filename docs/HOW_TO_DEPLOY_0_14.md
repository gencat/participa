# KEEP IN MIND WHEN DEPLOYING 0.14

Take a look to the Changelog https://github.com/decidim/decidim/blob/0.14-stable/CHANGELOG.md to specific actions.

## After DEPLOYING 0.14
- The rake task of orphan records must be executed, before executing migrations of 0.15, if they don't fail while trying to find the organization of a proposal to add it in Catalan.
- You need to execute this two tasks:
`RAILS_ENV=production bundle exec rake participa:fix_orphan_component_records`
`RAILS_ENV=production bundle exec rake participa:fix_orphan_proposal_records`
- Note: This may take some time, there are many orphaned records
