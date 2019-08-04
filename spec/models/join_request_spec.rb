require 'rails_helper'

RSpec.describe JoinRequest, type: :model do
  describe 'バリデーションのテスト' do
    let(:community) { FactoryBot.create(:community) }
    let(:user) { FactoryBot.create(:user) }

    it 'messageが空のとき無効であること' do
      join_request = FactoryBot.build(:join_request, message: nil)
      join_request.valid?
      expect(join_request.errors[:message]).to include('を入力してください')
    end

    it 'messageが300文字の時有効であること' do
      join_request = FactoryBot.build(:join_request, message: 'm' * 300)
      expect(join_request).to be_valid
    end

    it 'messageが301文字の時無効であること' do
      join_request = FactoryBot.build(:join_request, message: 'm' * 301)
      join_request.valid?
      expect(join_request.errors[:message]).to include('は300文字以内で入力してください')
    end

    it 'statusが空のとき無効であること' do
      join_request = FactoryBot.build(:join_request, status: nil)
      join_request.valid?
      expect(join_request.errors[:status]).to include('を入力してください')
    end

    it 'statusのdefault値がuncheckedであること' do
      join_request = JoinRequest.create(message: 'hogehoge',
                                        community_id: community.id,
                                        user_id: user.id)
      expect(join_request.status).to eq 'unchecked'
    end
  end
end
