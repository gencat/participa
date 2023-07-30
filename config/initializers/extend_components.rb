# frozen_string_literal: true

def add_attribute_to_global_settings(component, attr_name, type, default: false)
  component.settings(:global).attribute(attr_name.to_sym, type: type, default: default)
end

# Extends the Decidim::Surveys component.

component = Decidim.find_component_manifest :surveys
add_attribute_to_global_settings(component, :send_confirmation_email, :boolean)
