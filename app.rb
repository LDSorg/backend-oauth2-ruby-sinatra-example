require "sinatra"
require "json"
require_relative "sinatra_ssl"
require "oauth3"
require "dotenv"

Dotenv.load

enable :sessions

set :public_folder, File.join(File.dirname(File.absolute_path(__FILE__)), "public").to_s
set :bind, "0.0.0.0"
set :port, ENV["APP_PORT"]

sleep 0.25
puts ""
puts ""
puts "Loading #{ENV['APP_PROTOCOL']}://#{ENV['APP_HOST']} ..."
puts ""
puts File.join(File.dirname(File.absolute_path(__FILE__)), "certs", "ca").to_s
puts ""
sleep 1

class Registrar
  def initialize(filename)
    @filename = filename

    File.open(filename, "r") do |f|
      @store = JSON.parse(f.read())
    end
  end

  def options
    return {
      allowed_ips: [],
      allowed_domains: [ "local.ldsconnect.org", "local.lds.io" ]
    }
  end

  def register(provider_uri, id, secret)
    @store[provider_uri] = { 'id' => id, 'secret' => secret }
    File.open(@filename, "w") do |f|
      f.write(JSON.pretty_generate(@store))
    end
  end

  def get(provider_uri)
    @store[provider_uri]
  end
end

configure do
  @@registrar = Registrar.new('db.json')
  @@oauth3 = Oauth3.new(
    @@registrar,
    {
      redirect_uri: "https://local.ldsconnect.org:8043/api/oauth3/authorization_code_callback",
      scope: []
    }
  )
end

get "/" do
  File.read(File.join("public", "index.html"))
end

get %r{/api/oauth3/authorization_redirect/(.*)} do |provider_uri|
  provider_uri = @@oauth3.normalize_provider_uri(provider_uri)
  # TODO create strategy here params['provider_uri']
  redirect to(@@oauth3.authorize_url(provider_uri))
end

get "/api/oauth3/authorization_code_callback" do
  provider_uri = params[:provider_uri]
  provider_uri = @@oauth3.normalize_provider_uri(provider_uri)

  if code = params[:code] 
    if token = @@oauth3.get_token(provider_uri, code).token
      session[:provider_uri] = provider_uri
      session[:token] = token
    end
  end
  File.read(File.join("public", "oauth-close.html"))
end

get "/account.json" do
  provider_uri = session[:provider_uri]

  if token = session[:token]
    profile = @@oauth3.get_profile(provider_uri, token)
  end

  if profile
    return "{ \"user\": #{profile.body} }"
  end

  { error: { message: "ohnoes" } }
end
