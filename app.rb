require "dotenv"
require "sinatra"
require_relative "sinatra_ssl"
require "ldsconnect"

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

before "*" do
  ca_path = File.join(File.dirname(File.absolute_path(__FILE__)), "certs", "ca").to_s

  @strategy = LdsConnect.new(
    ENV["APP_ID"],
    ENV["APP_SECRET"],
    {
      redirect_uri: "#{ENV['APP_PROTOCOL']}://#{ENV['APP_HOST']}/auth/ldsconnect/callback",
      # the intermediate and root for local.ldsconnect.org happen to be the same needed for ldsconnect.org
      ssl: { ca_path: ca_path },
      scope: []
    }
  )
end

get "/" do
  File.read(File.join("public", "index.html"))
end

get "/auth/ldsconnect" do
  redirect to(@strategy.authorize_url)
end

get "/auth/ldsconnect/callback" do
  if code = params[:code] 
    if token = @strategy.get_token(code).token
      session[:token] = token
    end
  end
  File.read(File.join("public", "oauth-close.html"))
end

get "/account.json" do
  if token = session[:token]
    profile = @strategy.get_profile(token)
  end

  if profile
    return "{ \"user\": #{profile.body} }"
  end
  { error: { message: "ohnoes" } }
end
