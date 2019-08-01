require 'rails_helper'

RSpec.describe 'CommunitiesController', type: :request do
  describe 'GET: /api/communities - コミュニティ一覧の取得' do
    let!(:community) { FactoryBot.create(:community, title: 'hoge') }

    it '200が返ってくること' do
      get communities_path
      expect(response).to have_http_status(200)
      expect(response).to be_successful
    end

    it 'コミュニティ一覧が返ってくること' do
      get communities_path
      res_json = JSON.parse(response.body)
      expect(res_json[0]['title']).to eq 'hoge'
    end
  end

  describe 'POST: /api/communities - コミュニティを作成' do
    let!(:user) { FactoryBot.create(:user) }
    let(:community_params) { FactoryBot.attributes_for(:community) }
    let(:invalid_community_params) { FactoryBot.attributes_for(:community, title: nil) }

    describe '認証済みのユーザーとして' do
      context '有効な属性値の時' do
        it '正常にコミュニティが作成出来ること' do
          token = log_in_as(user)
          aggregate_failures do
            expect {
              post communities_path, headers: generate_login_header(token), params: community_params
            }.to change(Community, :count).by(1)
            expect(response).to have_http_status '201'
          end
        end
      end

      context '無効な属性値の時' do
        it 'コミュニティが作成されず、400が返ってくること' do
          token = log_in_as(user)
          aggregate_failures do
            expect {
              post communities_path, headers: generate_login_header(token), params: invalid_community_params
            }.to_not change(Community, :count)
            expect(response).to have_http_status '400'
          end
        end
      end
    end

    describe 'ゲストユーザーとして' do
      it 'コミュニティが作成出来ず、401が返ってくること' do
        aggregate_failures do
          expect {
            post communities_path, params: community_params
          }.to_not change(Community, :count)
          expect(response).to have_http_status '401'
        end
      end
    end
  end

  describe 'DELETE: /api/communities/:id - コミュニティの削除' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let!(:community) { FactoryBot.create(:community, owner: user) }

    describe '認証済みのユーザーとして' do
      context 'コミュニティのオーナーのリクエスト' do
        it 'コミュニティを削除出来き、204が返ってくること' do
          token = log_in_as(user)
          aggregate_failures do
            expect {
              delete community_path(community), headers: generate_login_header(token)
            }.to change(Community, :count).by(-1)
            expect(response).to have_http_status '204'
          end
        end
      end

      context 'コミュニティのオーナーではないユーザーのリクエスト' do
        it 'コミュニティを削除出来ず、402が返ってくること' do
          token = log_in_as(other_user)
          aggregate_failures do
            expect {
              delete community_path(community), headers: generate_login_header(token)
            }.to_not change(Community, :count)
            expect(response).to have_http_status '402'
          end
        end
      end
    end

    describe 'ゲストユーザーとして' do
      it 'コミュニティを削除出来ず、401が返ってくること' do
        aggregate_failures do
          expect {
            delete community_path(community)
          }.to_not change(Community, :count)
          expect(response).to have_http_status '401'
        end
      end
    end
  end

  describe 'PUT /api/communities/:id - コミュニティの編集' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let!(:community) { FactoryBot.create(:community, owner: user, title: 'no update hoge') }

    describe '認証済みのユーザーとして' do
      context 'コミュニティのオーナーのリクエスト' do
        it 'コミュニティを編集出来き、200が返ってくること' do
          token = log_in_as(user)
          aggregate_failures do
            put community_path(community), headers: generate_login_header(token), params: { title: 'update hoge!' }
            json = JSON.parse(response.body)
            expect(json["title"]).to eq 'update hoge!'
            expect(response).to have_http_status '200'
          end
        end
      end

      context 'コミュニティのオーナーではないユーザーのリクエスト' do
        it 'コミュニティを編集出来ず、402が返ってくること' do
          token = log_in_as(other_user)
          aggregate_failures do
            put community_path(community), headers: generate_login_header(token), params: { title: 'update hoge!' }
            expect(community.reload[:title]).to eq 'no update hoge'
            expect(response).to have_http_status '402'
          end
        end
      end
    end

    describe 'ゲストユーザーとして' do
      it 'コミュニティを編集出来ず、401が返ってくること' do
        aggregate_failures do
          put community_path(community), params: { title: 'update hoge!' }
          expect(community.reload[:title]).to eq 'no update hoge'
          expect(response).to have_http_status '401'
        end
      end
    end
  end

  describe 'GET: /api/communities/:id - コミュニティの詳細取得' do
    describe '認証済みのユーザーとして' do
      describe 'コミュニティメンバー' do
        context '公開レベルがanyoneの場合' do
          it '取得出来る'
        end

        context '公開レベルがapprovalの場合' do
          it '取得出来る'
        end
      end

      describe 'not コミュニティメンバー' do
        context '公開レベルがanyoneの場合' do
          it '取得出来る'
        end

        context '公開レベルがapprovalの場合' do
          it '取得出来ない'
        end
      end
    end

    describe 'ゲストユーザーとして' do
      context '公開レベルがanyoneの時' do
        it 'コミュニティ詳細を取得出来ないこと'
      end

      context '公開レベルがapprovalの時' do
        it 'コミュニティ詳細を取得出来ないこと'
      end
    end
  end
end
