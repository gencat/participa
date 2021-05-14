# frozen_string_literal: true

Decidim::ParticipatoryProcess.class_eval do
  belongs_to :decidim_type,
             class_name: "DecidimType",
             optional: true
end
