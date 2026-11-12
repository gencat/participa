# Decidim::Recaptcha
This module use Recaptcha v3 instead invisible_captcha in Decidim.

## How it works
- `app/overrides/decidim/devise/registrations/new/recaptcha_v3.html.erb.deface`: Deface override that replaces `invisible_captcha` with `recaptcha_v3(action: "registration")` in the sign up form.
- `app/decorators/decidim/commands/create_registration_decorator.rb`: verifies the reCAPTCHA response when creating the user.

The module requires `deface` (see `lib/decidim/recaptcha.rb`), so it works in any app, even if `deface` is not in its Gemfile.

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
cd decidim-recaptcha
bundle
bundle exec rake test_app
```

And run tests:

```bash
LANG=en bundle exec rspec spec
``` 

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
