# frozen_string_literal: true

Decidim::ParticipatoryProcess.class_eval do
  belongs_to :decidim_type,
             foreign_key: "decidim_type_id",
             class_name: "DecidimType"
end
