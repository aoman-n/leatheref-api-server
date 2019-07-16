module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      access_token = request.params['access-token']

      if access_token.present?
        decode_token = DecodeToken.new(access_token)
        user = decode_token.get_user
        if user && user.valid_user?(decode_token.decoded_token['token'])
          user
        end
      end
    end
  end
end
