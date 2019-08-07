require 'rails_helper'

RSpec.describe Comeet, type: :model do
  describe 'バリデーションのテスト' do
    let(:community) { FactoryBot.create(:community) }
    let(:user) { FactoryBot.create(:user) }

    it 'messageが空だと無効であること' do
      comeet = community.comeets.new(message: nil, user_id: user.id)
      comeet.valid?
      expect(comeet.errors[:message]).to include('を入力してください')
    end

    it 'messageが500文字だと有効であること' do
      comeet = community.comeets.new(message: 'a' * 500, user_id: user.id)
      expect(comeet).to be_valid
    end

    it 'messageが501文字だと無効であること' do
      comeet = community.comeets.new(message: 'a' * 501, user_id: user.id)
      comeet.valid?
      expect(comeet.errors[:message]).to include('は500文字以内で入力してください')
    end
  end
end
