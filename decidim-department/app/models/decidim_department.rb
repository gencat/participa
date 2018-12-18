# frozen_string_literal: true

class DecidimDepartment < ApplicationRecord
  include Decidim::Traceable
  include Decidim::Loggable
end
