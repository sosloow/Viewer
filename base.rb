require 'sinatra/base'
require 'haml'
require './models' 

class App < Sinatra::Base

  enable :sessions, :logging
  set :root, File.dirname(__FILE__)
  set :server, 'thin'

  get '/' do
    Comic.scan_manga_dir
    @comics = Comic.all
    haml :index
  end

  get '/reader/:id' do |id|
    p @comic = Comic.first(id: id)
    haml :reader, locals: {comic: @comic}
  end

  get '/edit/:id' do |id|
    p @comic = Comic.first(id: id)
    haml :editor
  end

  run! if app_file == $0

end
