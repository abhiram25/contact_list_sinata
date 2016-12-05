require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/content_for"
require "tilt/erubis"
require "pry"

configure do
  enable :sessions
  set :sessions_secret, 'secret'
end

configure do
  set :erb, :escape_html => true
end

before do
	@data = YAML.load_file("contacts.yaml")
end

get "/" do
	@categories = @data.keys
	erb :home
end

get "/add_contact" do
	erb :add_contact
end

get "/:category" do
	@category = params[:category]
	@contacts = @data[@category]
	erb :category
end

get "/:category/:contact_id/:name" do
	@name = params[:name].gsub("%", " ")
	contact_id = params[:contact_id]
	category = params[:category]
	@email = @data[category][contact_id][:email]
	@phone = @data[category][contact_id][:phone]
	erb :contact
end

post "/add_contact" do
	first_name = params[:first_name]
	last_name = params[:last_name]
	email = params[:email]
	phone = params[:phone]
	id = SecureRandom.uuid.split("-")[0]
	category = params[:category]
	@data[category] = {} unless @data[category]
	@data[category][id] = {:first_name => "#{first_name}", :last_name => "#{last_name}", :email => "#{email}", :phone => "#{phone}"}
	data = @data
	File.open("contacts.yaml","w") {|file| YAML.dump(data, file)}
	redirect "/"
end
