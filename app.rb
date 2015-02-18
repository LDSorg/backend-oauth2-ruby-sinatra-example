require "dotenv"
require "sinatra"
require "ldsconnect"

Dotenv.load

enable :sessions

set :public_folder, File.dirname(__FILE__) + "/public"
set :bind, "0.0.0.0"
set :port, 4080

before "*" do
  @strategy = LdsConnect.new(
    ENV["APP_ID"],
    ENV["APP_SECRET"],
    {
      redirect_uri: "http://local.ldsconnect.org:4080/auth/ldsconnect/callback",
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
    return output = "{ \"user\": #{profile.body} }"
  end
  { error: { message: "ohnoes" } }
end
