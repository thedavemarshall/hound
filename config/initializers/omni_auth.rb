OmniAuth.config.logger = Rails.logger

# FOR LOCAL TESTING ONLY
# OmniAuth.config.add_mock(:github, {:uid => '12345'})

Rails.application.config.middleware.use OmniAuth::Builder do
  setup = ->(env) do
    options = GithubAuthOptions.new(env)
    env["omniauth.strategy"].options.merge!(options.to_hash)
  end

  provider(
    :github,
    ENV['GITHUB_CLIENT_ID'],
    ENV['GITHUB_CLIENT_SECRET'],
    {
      setup: setup,
      client_options: {
        site: 'https://github.groupondev.com/api/v3',
        authorize_url: 'https://github.groupondev.com/login/oauth/authorize',
        token_url: 'https://github.com/groupondev.com/login/oauth/access_token'
      }
    }
  )
end
