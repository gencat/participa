# frozen_string_literal: true

# Inserts the attachments count <td> after the "Evaluators" <td>.
Deface::Override.new(
  virtual_path: "decidim/proposals/admin/proposals/_proposal-tr",
  name: "proposals_admin_tr_attachments_td",
  original: "c1256e7ba75bd431d03eddac54dd913e15e7dc10",
  insert_after: "td.evaluators-count",
  text: <<~EOHTML
    <% if current_component.settings.attachments_allowed? %>
      <td data-label="<%= t("models.proposal.fields.attachments", scope: "decidim.proposals") %>">
        <%= proposal.attachments.size %>
      </td>
    <% end %>
  EOHTML
)
