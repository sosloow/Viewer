require 'sinatra/base'
require './models'
require 'haml'

class App < Sinatra::Base

enable :sessions, :logging, :dump_errors
set :app_file, __FILE__
set :server, %w[thin mongrel webrick]

get '/' do
  @comics = Comic.all
  haml :index
end

after do
  puts response.status
end

if app_file == $0
  run! 
end

end
