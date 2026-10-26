# frozen_string_literal: true

# Adds the attachments field to the admin static page form (except for the terms of service page).
# The attributes are handled by app/decorators/decidim/admin/static_pages_form_decorator.rb.
Deface::Override.new(virtual_path: "decidim/admin/static_pages/_form",
                     name: "static_page_form_attachments",
                     insert_after: "div.row.column:has(erb[loud]:contains('number_field :weight'))",
                     original: "f262dbb35b9efa006a99115ff87df970da3c5bb0",
                     text: <<~ERB)
                       <% unless form.object.slug == "terms-of-service" %>
                         <div class="row column">
                           <%= form.attachment :documents,
                                               multiple: true,
                                               label: t("decidim.admin.static_pages.form.add_attachments"),
                                               button_label: t("decidim.admin.static_pages.form.add_attachments"),
                                               button_edit_label: t("decidim.admin.static_pages.form.edit_attachments"),
                                               button_class: "button button__sm button__transparent-secondary mt-2 md:w-auto w-full",
                                               help_i18n_scope: "decidim.forms.file_help.file",
                                               help_text: t("decidim.admin.static_pages.form.attachment_legend") %>
                         </div>
                       <% end %>
                     ERB
