# participa

Citizen Participation and Open Government application.

This is the open-source repository for participa, based on [Decidim](https://github.com/decidim/decidim).

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

## Testing

Run `rake decidim:generate_external_test_app` to generate a dummy application.

Require missing factories in `spec/factories.rb`

Add `require "rails_helper"` to your specs and execute them from the **root directory**, i.e.:

`rspec decidim-process-extended/spec/serializers/decidim/participatory_processes/participatory_process_serializer_spec.rb`

## Open Data

Public information from Processes and Normative consultations can be accessed at [https://analisi.transparenciacatalunya.cat/](https://analisi.transparenciacatalunya.cat/dataset/Participa-Gencat/dazj-skq4), which is powered by [Socrata](https://socrata.com/).

The data is periodically updated using the [`soda-ruby gem`](https://github.com/socrata/soda-ruby) to access the [Socrata Open Data API](https://dev.socrata.com/).

The necessary credentials are:
```
# Socrata Open Data API, or SODA configuration.
SODA_DOMAIN: "soda.demo.socrata.com"
SODA_USERNAME: "user@example.com"
SODA_PASSWORD: "password"
SODA_APP_TOKEN: "app_token"
SODA_DATASET_IDENTIFIER: "dataset_identifier"
```

There are two rake tasks available to interact with this data:

- `rake socrata:export` to export the data to a file
- `rake socrata:publish` to update the remote Socrata dataset

These tasks use the following module and class:

- `Socrata` found at `lib/`
- `Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializer` found at `decidim-process-extended/app/serializers/`

