require 'rubygems'
require 'sinatra'
require 'haml'
  
 get '/' do
   haml :index
 end

after do
  puts response.status
end
