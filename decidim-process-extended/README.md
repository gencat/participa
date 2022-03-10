# Decidim::Process::Extended
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'decidim-process-extended'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install decidim-process-extended
$ bin/rails decidim_process_extended:install:migrations
```

## Testing

Create a dummy app in your application (if not present):

```bash
bin/rails decidim:generate_external_test_app
cd spec/decidim_dummy_app/
bundle exec rake decidim_type:install:migrations
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
