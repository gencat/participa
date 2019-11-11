# Change Log
**Upgrade notes:**

- **Added**: Decorator for the ParticipatoryProcessGroupsController#destroy method to avoid admin users to accidentally delete the process group that defines regulations. [#110](https://github.com/gencat/participa/pull/110)
- **Changed**: Upgrade Decidim::DepartmentAdmin module version[#103](https://github.com/gencat/participa/pull/103)
- **Fixed**: Fix assignation of type when copying ParticipatoryProcess [#102](https://github.com/gencat/participa/pull/102)
- **Fixed**: Fix color share-link button on /meetings path[#101](https://github.com/gencat/participa/pull/101)
- **Changed**: Use branch decidim 0.18-stable. [#101](https://github.com/gencat/participa/pull/101)
- **Fixed**: Fix permissions on decidim-type, just admin can access[#101](https://github.com/gencat/participa/pull/101)
- **Changed**: Dynamic scopes refactor and undo removal of Type customization. [#96](https://github.com/gencat/participa/pull/96)
- **Changed**: In order to get the feature "admin list has an area column" this PR upgrades `decidim-department_admin` module. [#95](https://github.com/gencat/participa/pull/95)
- **Added**: Separate `participatory_processes` by `process_group` in `select_recipients_to_deliver` in the admin's newsletter page. [#89](https://github.com/gencat/participa/pull/89)
- **Changed**: Stop department_admin from being displayed as a component. [#88](https://github.com/gencat/participa/pull/88)
- **Changed**: Hide `assembly_type` filter from `Assembly` index page as per request of Product Owner [#87](https://github.com/gencat/participa/pull/87)
- **Added**: Admin Department Module [#84](https://github.com/gencat/participa/pull/84)
- **Added**: Feat socrata open data. [#70](https://github.com/gencat/participa/pull/70)
Review the [README#open-data](https://github.com/gencat/participa/blob/master/README.md#open-data) section to find out the required actions to perform
- **Added**: Add new metadata fields to ParticipatoryProcesses. [#69](https://github.com/gencat/participa/pull/69)
- **Decidim::Verifications::MembersPicker** After installing and activating the verification module, review the [README usage section](https://github.com/gencat/decidim-verifications-members_picker/blob/0.0.2/README.md#usage) to execute the necessary actions
- **DecidimDepartment, DecidimTheme, DecidimType:** Only for upgrades from 0.18 or earlier versions [#67](https://github.com/gencat/participa/pull/67)

The logic from decidim-department, decidim-theme, decidim-type and decidim-admin-extended has been removed to the Decidim Standards, so you need to migrate the data to the new database tables:

```ruby
bundle exec rake move_custom_categorizations:all
```
Once you are sure that the data is migrated, you can create a migration in your app to remove the old decidim_departments, decidim_themes, decidim_types tables, and their relations:

```ruby
class RemoveDecidimCustomCategorizationTablesAfterMigrateToDecidimStandards < ActiveRecord::Migration[5.2]
  def up
    # Drop tables
    drop_table :decidim_departments
    drop_table :decidim_themes

    # Drop columns from surveys table
    remove_column :decidim_participatory_processes, :decidim_department_id
    remove_column :decidim_participatory_processes, :decidim_theme_id
  end
end
```
- **Upgraded**: Upgrade PARTICIPA to Decidim 0.18.0-master. [#66](https://github.com/gencat/participa/pull/66)
- **Upgraded**: Upgrade PARTICIPA to Decidim 0.17.0. [#65](https://github.com/gencat/participa/pull/65)
- **Removed**: Removed custom categories files in ParticipatorySpace and Proposal Component and and leave it as Decidim.  [\#45](https://github.com/gencat/participa/issues/45)

## Previous changes

Please check [Closed PR](https://github.com/gencat/participa/pulls?q=is%3Apr+is%3Aclosed) for previous changes.
