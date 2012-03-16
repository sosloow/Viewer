require 'mongo_mapper'

MongoMapper.config = { 'dev' => { 'uri' => ENV['MONGOHQ_URL'] } }
MongoMapper.connect('dev')

class Comic
  include MongoMapper::Document

  key :title, String, required: true
  key :images, Array, required: true
  key :description, String

  many :tags, :in => :tag_id

  def self.get_pics(path)
    if path.empty? then
      pics = Dir["*.*"]
    else
      pics = Dir.entries(path).map{ |file| (path+'/'+file).gsub('public/','')}
    end
    pics.keep_if{|file| file.match(/(.jpg|.png|.gif|.jpeg)$/)}
    pics.sort
  end

  def self.scan_manga_dir(path='public/manga')
    dirs = Dir.entries(path).keep_if{ |entry| File.directory?("#{path}/#{entry}") && entry!='.' && entry!='..' }
    dirs.keep_if{ |dir| Comic.find_by_title(dir.strip_path).nil? }
    dirs.each do |dir|
      Comic.create({ title: dir.strip_path, images: Comic.get_pics("#{path}/#{dir}"),
                   description: 'la-la-la' })
    end
    Comic.all
  end

  def have_tag(tag_name)
    tag = Tag.first(name: tag_name)
    if tag.nil? then
      tag = Tag.create name: tag_name
    end
    tag.push tagged: id
  end

  def tagged
    Tag.all(tagged: id)
  end

end

class Tag
  include MongoMapper::Document

  key :name, String, required: true
  key :tagged, Set

  def tag_on(comic)
    self.push tagged: comic.id
  end

  def on_comics
    
  end

end

class String
  def strip_path
    name = self.gsub(/[\s_]*(\[.*?\]|\(.*?\))[\s_]*/,'').match(/[\w\d\s\?\.:;'",@%&\<\>-]*/)
    if name.class == Array then
      name[0].to_s
    else
      name.to_s
    end
  end
end
