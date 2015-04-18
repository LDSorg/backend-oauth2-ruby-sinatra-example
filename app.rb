require "sinatra"
require "json"
require_relative "sinatra_ssl"
require_relative "queryparams"
#require_relative "oauth3"
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
      authorization_code_callback_uri: "https://local.ldsconnect.org:8043/api/oauth3/authorization_code_callback",
      authorized_redirect_uris: ["https://local.ldsconnect.org:8043/oauth3.html"],
      scope: []
    }
  )
end

get "/" do
  File.read(File.join("public", "index.html"))
end

get %r{/api/oauth3/authorization_redirect/(.*)} do |provider_uri|
  params.delete("splat")
  params.delete("captures")

  browser_state = params[:state] or params[:browser_state]
  if not browser_state
    return '{ "error": {' +
      ' "code": "E_NO_BROWSER_STATE",' +
      ' "message": "Developer Error: Please create a random string as &state={{random}}"' +
      '} }'
  end

  uri = @@oauth3.authorize_url(provider_uri, params)
  puts ""
  puts "Redirecting to #{uri}"
  puts ""
  puts ""

  redirect to(uri)
end

get "/api/oauth3/authorization_code_callback" do
  puts ""
  puts "Got callback"
  puts params
  puts ""
  puts ""

  result_params = @@oauth3.authorization_code_callback(params)

  # The result_params will contain the necessary success and failure
  # keys and values for oauth3.html to interpret and give you the
  # proper callback on the client
  if result_params[:access_token] and result_params[:provider_uri]
    provider_uri = result_params[:provider_uri]
    session[provider_uri] = {
      updated_at: Time.now,
      access_token: result_params[:access_token],
      provider_uri: result_params[:provider_uri]
    }
  end

  redirect to("oauth3.html#" + QueryParams.stringify(result_params))
end

get "/api/facebook/profile" do
  provider_uri = params[:provider_uri]

  if provider_uri
    token = session[provider_uri][:access_token]
  end

  if token
    profile = @@oauth3.get_profile(provider_uri, token)
  end
end

get "/api/ldsio/accounts" do
  provider_uri = params[:provider_uri]

  if provider_uri
    token = session[provider_uri][:access_token]
  end

  if token
    profile = @@oauth3.get_profile(provider_uri, token)
  end

  if profile
    return "{ \"user\": #{profile.body} }"
  end

  { error: { message: "ohnoes" } }
end
