require 'sinatra/base'
require 'haml'
require_relative 'models' 

class App < Sinatra::Base

  enable :sessions, :logging
  set :root, File.dirname(__FILE__)
  set :server, 'thin'

  get '/' do
    Comic.scan_manga_dir
    @comics = Comic.all
    haml :index
  end

  get '/manga' do 
    @comic = Comic.first(id: params[:id])
    
    case params[:e]
    when 'read'
      haml :reader, locals: {comic: @comic}
    when 'edit'
      haml :editor, locals: {comic: @comic}
    end
  end

  post '/manga' do
    comic = Comic.first id: params[:id]
    comic.set description: params[:descr]
    comic.have_many_tags params[:tags]
    redirect to '/'
  end

  run! if app_file == $0
  
end
