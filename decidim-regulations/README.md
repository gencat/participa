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
- To avoid admin users to accidentally delete the process groups that define which Processes should appear into Processes and Regulations (`Rails.application.config.process` and `Rails.application.config.regulation`), there's a decorator for the `ParticipatoryProcessGroupsController#destroy` method: `app/decorators/decidim/participatory_processes/admin/participatory_process_groups_controller_decorator.rb`. It is loaded in this module's engine `to_prepare` declaration.
- To hide the Regulations from the homepage "highlighted processes" block, there's a decorator for `HighlightedProcessesCell#highlighted_processes`: `app/decorators/decidim/participatory_processes/content_blocks/highlighted_processes_cell_decorator.rb`.

## Testing

Create a dummy app in your application (if not present):

```bash
cd decidim-regulations
bundle
DISABLE_SPRING=1 bundle exec rake test_app
```

And run tests:

```bash
bundle exec rspec spec
```


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
