require 'dropbox_sdk'

class DropBox

  attr_reader :session, :client, :auth_url
  APP_KEY = ENV['DROPBOX_KEY']
  APP_SECRET = ENV['DROPBOX_SECRET']
  ACCESS_TYPE = :dropbox

  def auth
    @session = DropboxSession.new(APP_KEY, APP_SECRET)
    @session.get_request_token
    @auth_url = @session.get_authorize_url
  end

  def get_access_token
    @session.get_access_token
    @client = DropboxClient.new(@session, ACCESS_TYPE)
  end

end
