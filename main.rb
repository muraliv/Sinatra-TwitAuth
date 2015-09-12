require "sinatra"
require "omniauth-twitter"
require "dotenv"
require "sinatra/reloader" if development?

Dotenv.load

use OmniAuth::Builder do
	provider :twitter, ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"]
end

configure do
	enable :sessions
end

helpers do
	def admin?
		session[:admin]
	end
end

get "/public" do
	"This is the public page - everybody is welcome!"
end

get "/private" do
	halt(401, "Not Authorized") unless admin?
	"This is the private page - members only"
end

get "/login" do
	redirect to("auth/twitter")
end

get "/auth/twitter/callback" do
	session[:admin] = true
	session[:username] = env["omniauth.auth"]["info"]["name"]
	"<h1>Hola #{session[:username]}!</h1>"
end

get "/auth/failure" do
	params[:message]
end

get "/logout" do
	session[:admin] = nil
	"You are now logged out"
end