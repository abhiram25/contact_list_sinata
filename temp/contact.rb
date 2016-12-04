require "sinatra"
require "sinatra/reloader" if development?
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
	@categories = YAML.load_file("categories.yaml")
	@contacts = YAML.load_file("contacts.yaml")
	binding.pry
end