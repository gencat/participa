# frozen_string_literal: true

Decidim::Assemblies::Admin::AssemblyForm.class_eval do
  attribute :show_home, Virtus::Attribute::Boolean
end
