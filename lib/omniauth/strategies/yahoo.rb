require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    #
    # Authenticate to Yahoo via OAuth and retrieve basic
    # user information.
    #
    class Yahoo < OmniAuth::Strategies::OAuth
      option :client_options, {
        :access_token_path => '/oauth/v2/get_token',
        :authorize_path => '/oauth/v2/request_auth',
        :request_token_path => '/oauth/v2/get_request_token',
        :site => 'https://api.login.yahoo.com'        
      }
            
      uid do 
        { access_token['xoauth_yahoo_guid'] }
      end
      
      info do
        user_hash = raw_info
        profile = user_hash['profile']
        nickname = user_hash['profile']['nickname']
        {
          'uid' => profile['guid'],
          'nickname' => profile['nickname'],
          'name' => profile['givenName'] || nickname,
          'image' => profile['image']['imageUrl'],
          'description' => profile['message'],
          'urls' => {
            'Profile' => profile['profileUrl'],
          },
        }
      end
      
      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get("http://social.yahooapis.com/v1/user/#{uid}/profile?format=json")
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
    end
  end
end

