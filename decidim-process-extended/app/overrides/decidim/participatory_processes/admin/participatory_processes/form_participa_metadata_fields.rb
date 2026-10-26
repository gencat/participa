# frozen_string_literal: true

# Add the Participa custom fields to the metadata section of the admin participatory process form.
Deface::Override.new(virtual_path: "decidim/participatory_processes/admin/participatory_processes/_form",
                     name: "add_participa_metadata_fields",
                     insert_after: "div#panel-metadata > div.row:first-child",
                     original: "a9938944e198306ac0629da960305a16c35355d0",
                     text: <<~ERB)
                       <div class="row">
                         <div class="columns">
                           <%= form.text_field :promoting_unit, aria: { label: :promoting_unit } %>
                         </div>

                         <div class="columns">
                           <%= form.text_field :facilitators, aria: { label: :facilitators } %>
                         </div>

                         <div class="columns">
                           <%= form.number_field :cost, aria: { label: :cost } %>
                         </div>

                         <div class="columns">
                           <%= form.email_field :email, aria: { label: :email } %>
                         </div>

                         <div class="columns">
                           <%= form.check_box :has_summary_record, aria: { label: :has_summary_record } %>
                         </div>
                       </div>
                     ERB
