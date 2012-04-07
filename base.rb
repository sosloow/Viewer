require 'sinatra/base'
require 'haml'
require_relative 'models' 
require_relative 'partials'
require_relative 'helpers'
require_relative 'dropbox'

class App < Sinatra::Base

  enable :sessions, :logging
  set :root, File.dirname(__FILE__)
  set :server, 'thin'
  set :username,'sosloow'
  set :token,'maketh1$longandh@rdtoremember'
  set :password,'topsecret'

  helpers Sinatra::Partials
  helpers Sinatra::Helpers

  get '/' do
    haml :index, locals: {lorem: Sinatra::Helpers::LOREM}
    #redirect '/list'
  end

  get '/list' do
    protected!
    @comics = Comic.all
    @comics.keep_if{ |comic| comic.tagged? params[:tag] } unless params[:tag].nil?
    haml :list
  end

  get '/manga' do 
    @comic = Comic.first(id: params[:id])
    case params[:e]
    when 'read'
      haml :reader, locals: {comic: @comic}   
    when 'edit'
      haml :editor, locals: {comic: @comic}
    when 'new'
      haml :comic_new, locals: {comic: @comic}
    end
  end

  post '/manga' do
    case params[:e]
    when 'read'
      post_comment id: params[:id], body: params[:body], poster: params[:poster]
      redirect back
    when 'edit'
      comic = Comic.first id: params[:id]
      comic.set description: params[:descr]
      comic.have_many_tags params[:tags]
      redirect to '/'
    when 'new'
      protected!
      files = params[:files]
      path = "#{ENV['DROPBOX_PATH']}/public/manga/#{params[:title]}"
      comic = Comic.create(title: params[:title],
                           description: params[:descr],
                           path: path,
                           images: files.map{ |file| file[:filename] })
      comic.have_many_tags params[:tags]
      files.each do |file|
        session[:box].client.put_file("#{path}/#{file[:filename]}",
                                      file[:tempfile])
      end
    end
  end

  get '/admin' do
    haml :admin unless admin?
    session[:box] ||= DropBox.new
    unless session[:box].session
      redirect session[:box].auth
    end
    unless session[:box].session.authorized?
      session[:box].get_access_token
    end
    redirect
  end

  get '/logout' do
    response.set_cookie(settings.username, false)
    redirect '/'
  end

  post '/login' do
    if params['username']==settings.username&&params['password']==settings.password
      response.set_cookie(settings.username,settings.token) 
      redirect '/'
    else
      redirect '/'
    end
  end

  get '/upload' do

    haml :upload
  end

  post '/upload' do
    file = params[:file]
    session[:box].client.put_file "public/manga/#{file[:filename]}", file[:tempfile]
    redirect '/upload'
  end

  run! if app_file == $0

end
