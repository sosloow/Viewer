module Sinatra::Helpers
  LOREM = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'

    def post_comment(array)
      array[:poster] = 'Anon' if array[:poster] == ''
      Comment.create comic_id: array[:id], body: array[:body], poster: (array[:poster])
    end

    def admin?
      request.cookies[settings.username] == settings.token
    end
    
    def protected!
      redirect '/admin' unless admin?
    end
end
