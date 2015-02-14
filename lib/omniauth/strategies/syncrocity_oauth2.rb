require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class SyncrocityOauth2 < OmniAuth::Strategies::OAuth2
      option :name, 'syncrocity_oauth2'

      option :skip_friends, true

      option :authorize_options, [:access_type, :hd, :login_hint, :prompt, :request_visible_actions, :redirect_uri]

      option :client_options, {
        :authorize_url => '/oauth/authorize',
        :token_url     => '/oauth/token'
      }

      args [:client_id, :client_secret, :site]

      def initialize(app, *args, &block) # rubocop:disable UnusedMethodArgument
        super
        options.client_options[:site] = options.site
      end

      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |k|
            params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
          end
        end
      end

      extra do
        hash = {}
        hash[:info] = user_info(access_token.token)
        prune! hash
      end

      uid do
        user_info(access_token.token)['id']
      end

      private

      def prune!(hash)
        hash.delete_if do |_, v|
          prune!(v) if v.is_a?(Hash)
          v.nil? || (v.respond_to?(:empty?) && v.empty?)
        end
      end

      def user_info(access_token)
        raw_response = client.request(:get, options.client_options[:site] + '/api/me', :params => {
          :access_token => access_token
        }).parsed
      end
    end
  end
end
