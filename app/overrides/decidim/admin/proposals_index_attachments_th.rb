# frozen_string_literal: true

# Inserts the "Attachments" column header after the "Valuators" <th>.
Deface::Override.new(
  virtual_path: "decidim/proposals/admin/proposals/index",
  name: "proposals_admin_index_attachments_th",
  insert_after: "thead th:nth-last-of-type(3)",
  text: <<~EOHTML
    <% if current_component.settings.attachments_allowed? %>
      <th>
        <%= t("models.proposal.fields.attachments", scope: "decidim.proposals") %>
      </th>
    <% end %>
  EOHTML
)
