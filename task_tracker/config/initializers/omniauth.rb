require 'oauth_strategy'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :auth_service, ENV['AUTH_KEY'], ENV['AUTH_SECRET'], scope: 'public write'
end
