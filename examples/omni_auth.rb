# Google's OAuth2 docs. Make sure you are familiar with all the options
# before attempting to configure this gem.
# https://developers.google.com/accounts/docs/OAuth2Login

Rails.application.config.middleware.use OmniAuth::Builder do
  # Default usage, this will give you offline access and a refresh token
  # using default scopes 'email' and 'profile'
  #
  provider :syncrocity_oauth2, ENV['SYNCROCITY_KEY'], ENV['SYNCROCITY_SECRET'], {
    :scope => 'email,profile'
  }

  # Manual setup for offline access with a refresh token.
  # The prompt must be set to 'consent'
  #
  # provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
  #   :access_type => 'offline',
  #   :prompt => 'consent'
  # }

  # Custom scope supporting youtube. If you are customizing scopes, remember
  # to include the default scopes 'email' and 'profile'
  #
  # provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
  #   :scope => 'http://gdata.youtube.com,email,profile,plus.me'
  # }

  # Custom scope for users only using Google for account creation/auth and do not require a refresh token.
  #
  # provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
  #   :access_type => 'online',
  #   :prompt => ''
  # }

  # To include information about people in your circles you must include the 'plus.login' scope.
  #
  # provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
  #   :skip_friends => false,
  #   :scope => "email,profile,plus.login"
  # }
end