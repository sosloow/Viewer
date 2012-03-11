require 'mongo_mapper'

class Comic

    include MongoMapper::Document
    set_database_name "veiwer-dev"

    key :title, String, required: true
    key :images, Array, required: true

end

Comic.delete_all
Comic.create title: "suppacomic", images: ['1.jpg','2.jpg']
