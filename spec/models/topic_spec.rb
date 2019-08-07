require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe 'バリデーションテスト' do
    it 'titleが空だと無効であること' do
      topic = FactoryBot.build(:topic, title: nil)
      topic.valid?
      expect(topic.errors[:title]).to include('を入力してください')
    end

    it 'titleが50文字だと有効であること' do
      topic = FactoryBot.build(:topic, title: 'a' * 50)
      expect(topic).to be_valid
    end

    it 'titleが51文字だと無効であること' do
      topic = FactoryBot.build(:topic, title: 'a' * 51)
      topic.valid?
      expect(topic.errors[:title]).to include('は50文字以内で入力してください')
    end
  end
end
