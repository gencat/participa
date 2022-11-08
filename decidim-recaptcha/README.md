# Decidim::Recaptcha
This module use Recaptcha v3 instead invisible_captcha in Decidim.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'decidim-recaptcha'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install decidim-recaptcha
```


## Testing

Create a dummy app in your application (if not present):

```bash
bin/rails decidim:generate_external_test_app
```

And run tests:

```bash
LANG=en bundle exec rspec spec
``` 

## Overrides



## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
