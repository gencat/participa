# Decidim::Process::Extended
This module add some functionalities to participatory spaces.

For participatory processes:
- Add new fields: cost, has_summary_record, promoting_unit, facilitators and email.
  - They are added to the admin form with a Deface override (`app/overrides/decidim/participatory_processes/admin/participatory_processes/_form/participa_metadata_fields.html.erb.deface`) and copied when a process is duplicated (`duplicate_participatory_process_decorator.rb`).
- Show an alert in the admin of "Normativa" processes when the proposals component is not published (Deface override in `app/overrides/layouts/decidim/admin/participatory_process/proposal_component_alert.html.erb.deface`).

For participatory spaces (process and assemblies):
- Send an internal notification and an email to admins when a participatory space is created and published.
- Add a notification setting for admins to enabled/disabled these notifications

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'decidim-process-extended'
```

And then execute:
```bash
bundle install
bin/rails decidim_process_extended:install:migrations
bin/rails db:migrate
```

## Testing

Create a dummy app in your application (if not present):

```bash
bin/rails decidim:generate_external_test_app
cd spec/decidim_dummy_app/
bundle exec rake decidim_process_extended:install:migrations
DISABLE_SPRING=1 RAILS_ENV=test bundle exec rails db:migrate
cd ../..
```

And run tests:

```bash
LANG=en bundle exec rspec spec
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
