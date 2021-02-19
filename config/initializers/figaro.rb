# frozen_string_literal: true

env= Rails.env
if env.development?
  Figaro.require_keys(
    "DB_DATABASE",
    "DB_PASSWORD",
    "DB_USERNAME"
  )
elsif env.test? && !ENV["CI"]
  Figaro.require_keys(
    "TEST_DB_DATABASE",
    "TEST_DB_PASSWORD",
    "TEST_DB_USERNAME"
  )
elsif env.preprod? || env.production?
  Figaro.require_keys(
    "DATABASE_URL"
  )
end
