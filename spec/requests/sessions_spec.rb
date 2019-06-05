require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe "ログイン機能の検証: POST /login" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:not_activated_user) { FactoryBot.create(:unactivated_user) }

    context "ゲストユーザー" do
      it "404が返ってくること" do
        post login_path, params: {
          email: "gestuser@example.com",
          password: "password",
          password_confirmation: "password"
        }
        expect(response).to have_http_status "404"
      end
    end

    context "アクティベーションが完了していないユーザー" do
      it "401が返ってくること" do
        user_params = FactoryBot.attributes_for(:unactivated_user)
        post login_path, params: {
          email: user_params[:email],
          password: user_params[:password],
          password_confirmation: user_params[:password]
        }
        expect(response).to have_http_status "401"
      end
    end

    context "アクティベーション済みユーザー" do

      before do
        @user_params = FactoryBot.attributes_for(:user)
      end

      it "有効なパラメータであればtokenが返ってくること" do
        post login_path, params: {
          email: @user_params[:email],
          password: @user_params[:password],
          password_confirmation: @user_params[:password]
        }
        expect(response).to have_http_status "200"
        json = JSON.parse(response.body)
        expect(json).to include("token")
      end

      it "パスワードが間違えていると、401が返ってくること" do
        post login_path, params: {
          email: @user_params[:email],
          passowrd: "hogege",
          password_confirmation: @user_params[:password]
        }
        expect(response).to have_http_status "401"
      end

      it "パスワード確認が間違えていると401が返ってくること" do
        post login_path, params: {
          email: @user_params[:email],
          passowrd: @user_params[:password],
          password_confirmation: "hogegen"
        }
        expect(response).to have_http_status "401"
      end

      it "emailが間違えていると404が返ってくること" do
        post login_path, params: {
          email: "hogege@example.com",
          passowrd: @user_params[:password],
          password_confirmation: @user_params[:password_confirmation]
        }
        expect(response).to have_http_status "404"
      end
    end
  end

  describe "ログアウト機能の検証: DELETE /logout" do
    let!(:user) { FactoryBot.create(:user) }

    it "ログインしてなければ..." do

    end

    it "ログイン中のユーザーがログアウト出来ること" do
      user_params = FactoryBot.attributes_for(:user)
      post login_path, params: {
        email: user_params[:email],
        password: user_params[:password],
        password_confirmation: user_params[:password]
      }
      login_json = JSON.parse(response.body)
      token = login_json["token"]
      headers = { "authorization": " Bearer #{token}" }
      delete logout_path, headers: headers
      expect(response).to have_http_status "200"
      logout_json = JSON.parse(response.body)
      expect(logout_json["message"]).to eq "success log out"
    end
  end

end