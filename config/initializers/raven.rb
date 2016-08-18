require "raven"

Raven.configure do |config|
  sentry_private_dsn = Rails.application.secrets.sentry_private_dsn
  config.dsn = sentry_private_dsn if sentry_private_dsn
end
