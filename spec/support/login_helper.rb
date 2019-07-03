module LoginHelper
  def log_in_as(user)
    post login_path, params: {
      email: user[:email],
      password: 'password',
      password_confirmation: 'password',
    }
    json = JSON.parse(response.body)
    json['token']
  end

  def generate_login_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end
end
