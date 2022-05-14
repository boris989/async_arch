module OmniAuth
  module Strategies
    class AuthService < OmniAuth::Strategies::OAuth2
      option :name, :auth_service

      option :client_options, {
          :site => "http://localhost:3000/",
          :authorize_url => "http://localhost:3000/oauth/authorize"
      }

      uid { raw_info["public_id"] }

      info do
        {
            :email => raw_info["email"],
            :full_name => raw_info["full_name"],
            :active => raw_info["active"],
            :role => raw_info["role"],
            :public_id => raw_info["public_id"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/accounts/current').parsed
      end
    end
  end
end
