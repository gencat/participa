# frozen_string_literal: true

# Inserts the attachments count <td> after the "Valuators" <td>.
Deface::Override.new(
  virtual_path: "decidim/proposals/admin/proposals/_proposal-tr",
  name: "proposals_admin_tr_attachments_td",
  original: "8283579c95f0cfd7086fc8eeabfea86bd207a2f1",
  insert_after: "td.valuators-count",
  text: <<~EOHTML
    <% if current_component.settings.attachments_allowed? %>
      <td>
        <%= proposal.attachments.size %>
      </td>
    <% end %>
  EOHTML
)
