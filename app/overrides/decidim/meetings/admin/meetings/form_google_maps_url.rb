# frozen_string_literal: true

# Inserts a Google Maps URL field in the admin meeting form,
# visible only for in-person and hybrid meeting types.
# Overrides view: decidim/meetings/admin/meetings/_form
# Original: decidim_fork/decidim-meetings/app/views/decidim/meetings/admin/meetings/_form.html.erb
Deface::Override.new(
  virtual_path: "decidim/meetings/admin/meetings/_form",
  name: "meeting_form_google_maps_url",
  insert_before: "div.row.column:not(.iframe-fields--embed-type)[data-meeting-type='online']",
  text: <<~HTML
    <div class="row column" data-meeting-type="in_person">
      <%= form.text_field :google_maps_url, help_text: t(".google_maps_url_help") %>
    </div>
  HTML
)
