# Decidim::TopComments

Highlight in favor and against comments with more votes..

## Usage

TopComments will be available as a Component for a Participatory
Space.

## Installation

Add this lines to your application's Gemfile:

```ruby
gem 'decidim-top_comments'
gem 'deface', require: true
```

And then execute:

```bash
bundle install
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

## Contributing

Some interesting artifacts for this Decidim module:

* Extend `ProposalsController` to add the best-comments helpers
  * `decorators/decidim/proposals/proposals_controller_decorator.rb`
* Most voted comments block rendering custom partial `proposals/proposals/most_voted_comments.html.erb`
  * Rendering is done via `deface` override for `app/views/decidim/proposals/proposals/show.html.erb (decidim-proposals)` template.

Some deface tasks that were helpful during development:

```bash
bin/rake deface:get_result[decidim/proposals/proposals/show]
bin/rake deface:test_selector['decidim/proposals/proposals/show','erb[loud]:root:last-child']
```

These tasks should be run from the main application.

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
