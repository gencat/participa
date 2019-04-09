# Change Log
**Upgrade notes:**
- **DecidimDepartment, DecidimTheme, DecidimType:** Only for upgrades from 0.18 or earlier versions

The logic from decidim-department, decidim-theme, decidim-type and decidim-admin-extended has been removed to the Decidim Standards, so you need to migrate the data to the new database tables:

```ruby
bundle exec rake decidim_surveys:migrate_data_to_decidim_forms
```
Once you are sure that the data is migrated, you can create a migration in your app to remove the old decidim_departments, decidim_themes, decidim_types tables, and their relations:

```ruby
class RemoveDecidimCustomCategorizationTablesAfterMigrateToDecidimStandards < ActiveRecord::Migration[5.2]
  def up
    # Drop tables
    drop_table :decidim_departments
    drop_table :decidim_types
    drop_table :decidim_themes

    # Drop columns from surveys table
    remove_column :decidim_participatory_processes, :decidim_department_id
    remove_column :decidim_participatory_processes, :decidim_type_id
    remove_column :decidim_participatory_processes, :decidim_theme_id  
  end
end
```
- **Upgraded**: Upgrade PARTICIPA to Decidim 0.18.0-master. [#66](https://github.com/gencat/participa/pull/66)
- **Upgraded**: Upgrade PARTICIPA to Decidim 0.17.0. [#65](https://github.com/gencat/participa/pull/65)
- **Removed**: Removed custom categories files in ParticipatorySpace and Proposal Component and and leave it as Decidim.  [\#45](https://github.com/gencat/participa/issues/45)

## Previous changes

Please check [Closed PR](https://github.com/gencat/participa/pulls?q=is%3Apr+is%3Aclosed) for previous changes.
