require 'sinatra'
require 'haml'
require 'mongo_mapper'

MongoMapper.config = { 
  'dev' => { 'uri' => ENV['MONGOHQ_URL'] } }
MongoMapper.connect('dev')


get '/' do
  @comics = Comic.all
  haml :index
end


helpers do
  def get_pics(path)
	  if path.empty? then
	    pics = Dir["*.*"]
    else
      pics = Dir.entries(path)
    end
    pics.keep_if{|file| file.match(/(.jpg|.png|.gif|.jpeg)$/)}
    pics
  end

  def get_all_pics(path)
    result = {}
    dirs = Dir.entries(path).keep_if{ |entry| File.directory?("#{path}/#{entry}") && entry!='.' && entry!='..' }
    dirs.each do |dir|
      pics = get_pics("#{path}/#{dir}")
      name = dir.gsub(/\s*(\[.*?\]|\(.*?\))\s*/,'').match(/[\w\d\s\?\.:;'",@%&\<\>-]*/)
      if name.class == Array then
        name = name[0].to_s
      else
        name = name.to_s
      end  
      result[name] = pics
    end
    result
  end
end



class Comic
  include MongoMapper::Document

  key :title, String, required: true
  key :images, Array, required: true
end

class Source_folder
  include MongoMapper::Document
  
  key :path, String required: true
end
