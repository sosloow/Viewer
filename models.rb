require 'mongo_mapper'

#uri =  URI.parse(ENV['MONGOHQ_URL'])
#mongo_connection = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
#MongoMapper.database = 'viewer'
#p uri.user, uri.password
#MongoMapper.database.authenticate('sosloow', 'finntroll') 
MongoMapper.config = { 
  'dev' => { 'uri' => ENV['MONGOHQ_URL'] } }
MongoMapper.connect('dev')

class Comic

    include MongoMapper::Document

    key :title, String, required: true
    key :images, Array, required: true

end

Comic.delete_all
Comic.create title: "suppacomic", images: ['1.jpg','2.jpg']
