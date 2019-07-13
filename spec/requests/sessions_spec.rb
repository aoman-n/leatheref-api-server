require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'ログイン機能の検証: POST /login' do
    context 'ゲストユーザー' do
      it '404が返ってくること' do
        post login_path, params: {
          email: 'gestuser@example.com',
          password: 'password',
          password_confirmation: 'password',
        }
        expect(response).to have_http_status '404'
      end
    end

    context 'アクティベーションが完了していないユーザー' do
      it '401が返ってくること' do
        user_params = User.create!(
          login_name: 'hogemiso',
          email: 'hogemiso@example.com',
          password: 'password',
          password_confirmation: 'password',
          activated: false,
        )
        post login_path, params: {
          email: user_params[:email],
          password: 'password',
          password_confirmation: 'password',
        }
        expect(response).to have_http_status '401'
      end
    end

    context 'アクティベーション済みユーザー' do
      before do
        @user_params = User.create!(
          login_name: 'hogemiso',
          email: 'hogemiso@example.com',
          password: 'password',
          password_confirmation: 'password',
          activated: true,
          activated_at: Time.zone.now,
        )
      end

      it '有効なパラメータであればtokenが返ってくること' do
        post login_path, params: {
          email: @user_params[:email],
          password: 'password',
          password_confirmation: 'password',
        }
        expect(response).to have_http_status '200'
        json = JSON.parse(response.body)
        expect(json).to include('token')
      end

      it 'パスワードが違うと、401が返ってくること' do
        post login_path, params: {
          email: @user_params[:email],
          passowrd: 'hogege',
          password_confirmation: 'password',
        }
        expect(response).to have_http_status '401'
      end

      it 'パスワード確認が違うと401が返ってくること' do
        post login_path, params: {
          email: @user_params[:email],
          passowrd: 'password',
          password_confirmation: 'hogegen',
        }
        expect(response).to have_http_status '401'
      end

      it 'emailが間違えていると404が返ってくること' do
        post login_path, params: {
          email: 'hogege@example.com',
          passowrd: 'password',
          password_confirmation: 'password',
        }
        expect(response).to have_http_status '404'
      end
    end
  end

  describe 'ログアウト機能の検証: DELETE /logout' do
    before do
      @user_params = User.create!(
        login_name: 'hogemiso',
        email: 'hogemiso@example.com',
        password: 'password',
        password_confirmation: 'password',
        activated: true,
        activated_at: Time.zone.now,
      )
    end

    it 'ログイン中のユーザーがログアウト出来ること' do
      post login_path, params: {
        email: @user_params[:email],
        password: 'password',
        password_confirmation: 'password',
      }
      login_json = JSON.parse(response.body)
      token = login_json['token']
      delete logout_path, headers: { 'Authorization' => "Bearer #{token}" }
      expect(response).to have_http_status '200'
      logout_json = JSON.parse(response.body)
      expect(logout_json['message']).to eq 'success log out'
    end

    it 'ログインしてなければ400を返すこと' do
      delete logout_path
      expect(response).to have_http_status '400'
    end
  end
end
