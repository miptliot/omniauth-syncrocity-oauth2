require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class ChronocityOauth2 < OmniAuth::Strategies::OAuth2
      option :name, 'chronocity_oauth2'

      option :skip_friends, true

      option :authorize_options, [:access_type, :hd, :login_hint, :prompt, :request_visible_actions, :state, :redirect_uri]

      option :client_options, {
        :site          => 'http://liot.mipt.ru',
        :authorize_url => '/oauth/authorize',
        :token_url     => '/oauth/token'
      }

      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |k|
            params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
          end

          session['omniauth.state'] = params[:state] if params['state']
        end
      end

      extra do
        hash = {}
        hash[:id_token] = access_token['id_token']
        prune! hash
      end

      def custom_build_access_token
        if request.xhr? && request.params['code']
          verifier = request.params['code']
          client.auth_code.get_token(verifier, { :redirect_uri => 'postmessage'}.merge(token_params.to_hash(:symbolize_keys => true)),
                                     deep_symbolize(options.auth_token_params || {}))
        elsif verify_token(request.params['id_token'], request.params['access_token'])
          ::OAuth2::AccessToken.from_hash(client, request.params.dup)
        else
          orig_build_access_token
        end
      end
      alias_method :orig_build_access_token, :build_access_token
      alias_method :build_access_token, :custom_build_access_token

      private

      def prune!(hash)
        hash.delete_if do |_, v|
          prune!(v) if v.is_a?(Hash)
          v.nil? || (v.respond_to?(:empty?) && v.empty?)
        end
      end


      def image_size_opts_passed?
        !!(options[:image_size] || options[:image_aspect_ratio])
      end

      def image_params
        image_params = []
        if options[:image_size].is_a?(Integer)
          image_params << "s#{options[:image_size]}"
        elsif options[:image_size].is_a?(Hash)
          image_params << "w#{options[:image_size][:width]}" if options[:image_size][:width]
          image_params << "h#{options[:image_size][:height]}" if options[:image_size][:height]
        end
        image_params << 'c' if options[:image_aspect_ratio] == 'square'

        '/' + image_params.join('-')
      end

      def verify_token(id_token, access_token)
        return false unless (id_token && access_token)

        raw_response = client.request(:get, 'http://liot.mipt.ru/api/me', :params => {
          :access_token => access_token
        }).parsed
        raw_response['issued_to'] == options.client_id
      end
    end
  end
end
