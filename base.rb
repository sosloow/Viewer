require 'rubygems'
require 'sinatra'
require 'haml'

enable :sessions
set :session_secret, 'secret'

get '/' do
  haml :index
end

after do
  puts response.status
end
