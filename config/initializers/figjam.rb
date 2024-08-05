# frozen_string_literal: true

env= Rails.env
if env.development?
  Figjam.require_keys(
    "DB_DATABASE",
    "DB_PASSWORD",
    "DB_USERNAME"
  )
elsif env.test? && !ENV["CI"]
  Figjam.require_keys(
    "TEST_DB_DATABASE",
    "TEST_DB_PASSWORD",
    "TEST_DB_USERNAME"
  )
elsif env.preprod? || env.production?
  Figjam.require_keys(
    "DATABASE_URL"
  )
end
