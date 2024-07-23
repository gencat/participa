# frozen_string_literal: true

module Decidim::ParticipatoryProcessDecorator
  def self.decorate
    Decidim::ParticipatoryProcess.class_eval do
      belongs_to :decidim_type,
                 class_name: "DecidimType",
                 optional: true
    end
  end
end

::Decidim::ParticipatoryProcessDecorator.decorate
