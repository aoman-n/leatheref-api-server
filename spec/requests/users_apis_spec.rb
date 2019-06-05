require 'rails_helper'

RSpec.describe "Users API", type: :request do

  context "パラメータが有効な時" do
    it "ユーザーが作成されること" do
      allow(UserMailer).to receive_message_chain(:account_activation, :deliver_now)
      user_params = {
        name: 'example',
        email: 'example@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
      expect{
        post users_path, params: user_params
      }.to change{ User.count }.by(1)
      expect(UserMailer).to have_received(:account_activation)
      expect(response).to have_http_status "200"
    end
  end

  context "無効なパラメータの時" do
    it "ユーザーが作成されないこと" do
      user_params = {
        name: '',
        email: 'example@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
      expect{
        post users_path, params: user_params
      }.to change{ User.count }.by(0)
      expect(response).to have_http_status "401"
    end
  end

end
