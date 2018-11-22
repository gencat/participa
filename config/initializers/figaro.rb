env= Rails.env
unless env.development? or env.test?
  Figaro.require_keys(
    "DB_DATABASE",
    "DB_PASSWORD",
    "DB_USERNAME"
    )
end
