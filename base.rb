require 'sinatra'
require 'haml'
require 'mongo_mapper'

helpers do
  def get_pics(path)
	  if path.empty? then
	    pics = Dir["*.*"]
    else
      pics = Dir.entries(path).map{ |file| (path+'/'+file).gsub('public/','')}
    end
    pics.keep_if{|file| file.match(/(.jpg|.png|.gif|.jpeg)$/)}
    pics
  end

  def get_all_pics(path)
    result = {}
    dirs = Dir.entries(path).keep_if{ |entry| File.directory?("#{path}/#{entry}") && entry!='.' && entry!='..' }
    dirs.each do |dir|
      pics = get_pics("#{path}/#{dir}")
      name = dir.gsub(/[\s_]*(\[.*?\]|\(.*?\))[\s_]*/,'').match(/[\w\d\s\?\.:;'",@%&\<\>-]*/)
      if name.class == Array then
        name = name[0].to_s
      else
        name = name.to_s
      end  
      result[name] = pics
    end
    result
  end
  
  def fill_db 
    hash = get_all_pics('mango')
  end
  
end


class Comic
  include MongoMapper::Document

  key :title, String, required: true
  key :images, Array, required: true

#  many :tag 
end

MongoMapper.config = { 
  'dev' => { 'uri' => ENV['MONGOHQ_URL'] } }
MongoMapper.connect('dev')


get '/' do
  Comic.delete_all
  get_all_pics('public/manga').each do |title, pics|
    Comic.create :title => title, :images => pics
  end

  @comics = Comic.all
  haml :index
end
