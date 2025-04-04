# participa

Citizen Participation and Open Government application.

This is the open-source repository for "participa", based on [Decidim](https://github.com/decidim/decidim).

## Customizations

- `Decidim::Home`, customizes the main page of Decidim.
- `Decidim::Admin::SearchUser`, adds a search bar to Admin/users dashboard.
- `Decidim::Process::Extended`, customizes Decidim Participatory processes.
- `Decidim::Regulations`, adds Regulations, a new type of Participatory process.
- `Decidim::Admin::Extended`, customize admin menu adding custom configurations.
- `Decidim::Recaptcha`, use recaptcha instead invisible captcha.

## Deploying the app

An opinionated guide to deploy this app to Heroku can be found at [https://github.com/codegram/decidim-deploy-heroku](https://github.com/codegram/decidim-deploy-heroku).

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:
```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```
3. Visit `<your app url>/system` and login with your system admin credentials
4. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
5. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
6. Fill the rest of the form and submit it.

You're good to go!

### Machine translations

To enable automatic machine translations it should:

1. be defined an "ENABLE_MACHINE_TRANSLATIONS" ENV var set to "true":

```
# Figjam example
ENABLE_MACHINE_TRANSLATIONS: "true"
```

2. from "Configuration/Configuration" in the admin panel, the "Enable machine translations" checkbox must be selected and then click "Save". After that, a new "Machine translation display priority [] Original text first [x] Translated text first" option is displayed. Probably the second option is the more user friendly.

## Testing

Run `bin/rake decidim:generate_external_test_app` to generate a dummy application to test both the application and the modules.

Require missing factories in `spec/factories.rb`

Add `require "rails_helper"` to your specs and execute them from the root directory, i.e.:

```bash
bundle exec rake --backtrace -t

# or

bundle exec rspec decidim-process-extended/spec/serializers/decidim/participatory_processes/participatory_process_serializer_spec.rb`
```

## Open Data

Public information from _Participatory processes_ can be accessed at [https://analisi.transparenciacatalunya.cat/](https://analisi.transparenciacatalunya.cat/dataset/Participa-Gencat/dazj-skq4), which is powered by [Socrata](https://socrata.com/).

The data is periodically updated using the [`soda-ruby gem`](https://github.com/socrata/soda-ruby) to access the [Socrata Open Data API](https://dev.socrata.com/).

The necessary credentials are:
```
SODA_DOMAIN: "soda.demo.socrata.com"
SODA_USERNAME: "user@example.com"
SODA_PASSWORD: "password"
SODA_APP_TOKEN: "app_token"
SODA_DATASET_IDENTIFIER: "dataset_identifier"
```

There are two rake tasks available to interact with this data:

- `rake open_data:participatory_processes:export` to **export** the data to a CSV file
- `rake open_data:participatory_processes:publish_to_socrata` to **update** the remote Socrata dataset

The logic of these rake tasks has been extracted to a `Module` in `lib/open_data.rb`, and `ParticipatoryProcessSocrataSerializer`, located at `decidim-process-extended/app/serializers/decidim/participatory_processes`, is the `Class` responsible for transforming the objects into data for the Socrata dataset.
