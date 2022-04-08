# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/admin/participatory_process",
                     name: "add_alert_to_participatory_process_layout",
                     insert_before: "erb[loud]:contains('yield')",
                     text: "
                       <%= render partial: 'decidim/participatory_processes/admin/participatory_processes/proposal_component_alert' %>
                     ")
