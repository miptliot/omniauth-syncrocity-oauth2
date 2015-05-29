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

      args [:client_id, :client_secret, :site, :mail_domain]

      def initialize(app, *args, &block) # rubocop:disable UnusedMethodArgument
        super
        options.client_options[:site] = options.site
        options.client_options[:main_domain] = options.mail_domain
      end

      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |k|
            params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
          end
        end
      end

      info do
        if user_info['email'] == nil
          mail = "#{uid}@#{options.client_options[:main_domain]}"
        else
          mail = user_info['email']
        end

        {
          :name => "#{user_info['name']} #{user_info['surname']}",
          :email => mail,
          :first_name => user_info['name'],
          :last_name => user_info['surname'],
          :image => user_info['image'],
        }
      end

      extra do
        hash = {}
        hash[:info] = user_info
        prune! hash
      end

      uid do
        user_info['id']
      end

      private

      def prune!(hash)
        hash.delete_if do |_, v|
          prune!(v) if v.is_a?(Hash)
          v.nil? || (v.respond_to?(:empty?) && v.empty?)
        end
      end

      def user_info
        raw_response = client.request(:get, options.client_options[:site] + '/api/me', :params => {
          :access_token => access_token.token
        }).parsed
      end
    end
  end
end
