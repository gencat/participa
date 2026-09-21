# frozen_string_literal: true

# Inserts the "Attachments" column header after the "Valuators" <th>.
Deface::Override.new(
  virtual_path: "decidim/proposals/admin/proposals/_proposals-thead",
  name: "proposals_admin_index_attachments_th",
  original: "d819c75fcbdc48b6bab214a4cd282bba92ff400b",
  insert_after: "thead th:nth-last-of-type(3)",
  text: <<~EOHTML
    <% if current_component.settings.attachments_allowed? %>
      <th>
        <%= sort_link(query, :attachments_count, t("models.proposal.fields.attachments", scope: "decidim.proposals")) %>
      </th>
    <% end %>
  EOHTML
)
