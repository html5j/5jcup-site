Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
  ENV['FACEBOOK_CONSUMER_KEY'],
  ENV['FACEBOOK_CONSUMER_SECRET'],
  {
    :scope => 'email, offline_access', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}
  }

  provider :github,
  ENV['GITHUB_CONSUMER_KEY'],
  ENV['GITHUB_CONSUMER_SECRET']

  provider :twitter,
  ENV['TWITTER_CONSUMER_KEY'],
  ENV['TWITTER_CONSUMER_SECRET'],
  :client_options => {:authorize_path => '/oauth/authenticate'}

  provider :hatena,
  ENV['HATENA_CONSUMER_KEY'],
  ENV['HATENA_CONSUMER_SECRET'],
  :scope => "read_public"

end
