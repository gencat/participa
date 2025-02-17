# Decidim::Regulations
This module produces a "Regulations" participatory space. This participatory space is just like the Participatory Processes space.

The way to add ParticipatoryProcesses to Regulations is to group them into a Process Group and then configure the application with this Process Group's ID. Then this module takes the ParticipatoryProcesses from this group by filtering rows based on the following query:

```ruby
Decidim::ParticipatoryProcess.where("decidim_participatory_processes.decidim_participatory_process_group_id = ?", Rails.application.config.regulation)
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'decidim-regulations'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install decidim-regulations
```

## Overrides
To avoid admin users to accidentally delete the process group that defines which Processes should appear into Regulations, there's a decorator for the ParticipatoryProcessGroupsController#destroy method. The decorator is delared at `decidim-regulations/app/decorators/decidim/regulations/admin/avoid_deletion_of_regulations_group.rb` and is prepended to the controller in this module's engine `to_prepare` declaration.


## Ordering Regulations in the **Highlighted Regulations** content block:
Criteria for ordering which processes are displayed and in what order in the "Highlighted Regulations" content block:

1. Participatory process that belongs to the organization
2. Visible to the user (public/private)
3. Processes belong to a group marked as "regulations" 
4. The publication date is later than 01/01/1990
5. Ordered by publication date from most recent to oldest
6. Finally, the limit of visible processes configured in the back office is taken into account

Therefore, it does not take into account whether the process is promoted or not, whether it is active or completed, nor the phase dates.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
