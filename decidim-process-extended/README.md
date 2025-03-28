# Decidim::Process::Extended
This module add some functionalities to participatory spaces.

For participatory processes:
- Add new fields: cost, has_summary_record, promoting_unit, facilitators and email.

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
RAILS_ENV=test bundle exec rails db:migrate
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
