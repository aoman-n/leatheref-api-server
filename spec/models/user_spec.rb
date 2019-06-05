# == Schema Information
#
# Table name: users
#
#  id                :bigint(8)        not null, primary key
#  email             :string(255)      not null
#  name              :string(255)      not null
#  password_digest   :string(255)      not null
#  remember_digest   :string(255)
#  admin             :boolean          default(FALSE)
#  activation_digest :string(255)
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do

  it "有効な名前、Emailアドレス、パスワード、パスワード確認があればUserを作成出来ること" do
    user = User.new(
      name: "Aoba",
      email: "aobatest@example.com",
      password: "password",
      password_confirmation: "password"
    )
    expect(user).to be_valid
  end

  # name
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_length_of(:name).is_at_most(20) }
  # email
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_length_of(:email).is_at_most(250) }
  # password
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  it "emailが小文字に変換後DBに保存されること" do
    user = FactoryBot.create(:user, email: 'ExamPle@example.com')
    expect(user.reload.email).to eq "example@example.com"
  end

  describe "アドレスのフォーマットチェック" do
    # ユーザーのパラメータを仕込み、各テストでemailを上書きする。
    before do
      @user_params = FactoryBot.attributes_for(:user)
    end

    context "有効なアドレスの時" do
      valid_addresses = [
        "example+1@example.com",
        "example-1@example.com",
        "example_1@example.com"
      ]
      valid_addresses.each do |valid_address|
        it "アドレスが[#{valid_address}]" do
          user_params = @user_params.merge!(email: valid_address)
          user = User.new(user_params)
          expect(user).to be_valid
        end
      end
    end

    context "無効なアドレスの時" do
      invalid_addresses = [
        "user@example,com",
        "user_at_foo.org",
        "user.name@example.",
        "foo@bar_baz.com",
        "foo@bar+baz.com",
        "foo@bar..co",
        "foo@bar@piyo"
      ]
      invalid_addresses.each do |invalid_address|
        it "アドレスが[#{invalid_address}]" do
          user_params = @user_params.merge!(email: invalid_address)
          user = User.new(@user_params)
          user.valid?
          expect(user.errors[:email]).to_not be_empty
        end
      end
    end
  end

  describe "メソッドのテスト" do
    let(:user) { FactoryBot.build(:user) }

    it "#remember, #forget" do
      expect(user.remember_digest).to eq nil
      user.remember
      expect(user.remember_digest).to_not eq nil
      user.forget
      expect(user.remember_digest).to eq nil
    end
  end

end
