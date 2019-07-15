module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      puts '---------------- connect!!!'
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      p request.params
      access_token = request.params[:'access-token']
      p access_token
      User.find_by(id: access_token) || nill
      # if verified_user = User.find_by(id: cookies.encrypted[:user_id])
      #   verified_user
      # else
      #   reject_unauthorized_connection
      # end
    end
  end
end
