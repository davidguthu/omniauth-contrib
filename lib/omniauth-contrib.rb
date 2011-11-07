require "omniauth-contrib/version"
require "omniauth"

module OmniAuth
  module Strategies
    autoload :VKontakte,  'omniauth/strategies/vkontakte'
    autoload :Yahoo,  'omniauth/strategies/yahoo'
  end
end

OmniAuth.config.add_camelization 'vkontakte', 'VKontakte'
