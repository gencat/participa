# frozen_string_literal: true

# Inserts the "Attachments" column header after the "Evaluators" <th>.
Deface::Override.new(
  virtual_path: "decidim/proposals/admin/proposals/_proposals-thead",
  name: "proposals_admin_index_attachments_th",
  original: "040e819ff6150d05d9c1dc5b54deceea9c34ceed",
  insert_after: "thead th:nth-last-of-type(3)",
  text: <<~EOHTML
    <% if current_component.settings.attachments_allowed? %>
      <th>
        <%= sort_link(query, :attachments_count, t("models.proposal.fields.attachments", scope: "decidim.proposals")) %>
      </th>
    <% end %>
  EOHTML
)
