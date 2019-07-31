require 'rails_helper'

RSpec.describe Community, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { FactoryBot.create(:user) }
    let(:community) do
      Community.new(
        title: 'test community title',
        description: 'test community description',
        permittion_level: 'anyone',
        owner: user,
      )
    end

    it 'titleがないと無効であること' do
      community[:title] = nil
      community.valid?
      expect(community.errors[:title]).to be_present
    end

    it 'titleが31文字であると無効であること' do
      community[:title] = 'a' * 31
      community.valid?
      expect(community.errors[:title]).to be_present
    end

    it 'titleが30文字であると有効であること' do
      community[:title] = 'a' * 30
      expect(community).to be_valid
    end

    it 'titleに重複があると無効であること' do
      community.save
      new_commutity = Community.new(
        title: 'test community title',
        description: 'test community description',
        permittion_level: 'anyone',
        owner: user,
      )
      new_commutity.valid?
      expect(new_commutity.errors[:title]).to be_present
    end

    it 'descriptionがないと無効であること' do
      community[:description] = nil
      community.valid?
      expect(community.errors[:description]).to be_present
    end

    it 'descriptionが301文字であると無効であること' do
      community[:description] = 'a' * 301
      community.valid?
      expect(community.errors[:description]).to be_present
    end

    it 'descriptionが300文字であれば有効であること' do
      community[:description] = 'a' * 300
      expect(community).to be_valid
    end
  end

  describe 'scopeのテスト' do
    let(:user) { FactoryBot.create(:user) }

    it '#recent' do
      Community.create(title: 'test community title 1',
                       description: 'test community description',
                       permittion_level: 'anyone',
                       owner: user,
                       created_at: 1.day.ago,
                       updated_at: 1.day.ago)
      Community.create(title: 'test community title 2',
                       description: 'test community description',
                       permittion_level: 'anyone',
                       owner: user,
                       created_at: 1.day.from_now,
                       updated_at: 1.day.from_now)
      expect(Community.recent[0][:title]).to eq 'test community title 2'
    end
  end
end
