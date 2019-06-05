require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "account_activation", focus: true do
    let(:user) { FactoryBot.create(:user, :not_activate) }
    let(:mail) { UserMailer.account_activation(user) }

    it "ユーザのメールアドレスに送信すること" do
      expect(mail.to).to eq [user.email]
    end

    it "サポート用のメールアドレスから送信すること" do
      expect(mail.from).to eq ["support@example.com"]
    end

    it "正しい件名で送信すること" do
      expect(mail.subject).to eq "Account activation"
    end

    it "メールにアクティベーショントークンがセットされてること" do
      expect(mail.body.encoded).to match(/#{user.activation_token}/)
    end
  end

  describe "password_reset", focus: true do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.password_reset(user) }

    it "ユーザのメールアドレスに送信すること" do
      expect(mail.to).to eq [user.email]
    end

    it "サポート用のメールアドレスから送信すること" do
      expect(mail.from).to eq ["support@example.com"]
    end

    it "正しい件名で送信すること" do
      expect(mail.subject).to eq "Password reset"
    end

    it "メールにリセットトークンがセットされてること" do
      expect(mail.body.encoded).to match(/#{user.reset_token}/)
    end

    it "メール本文にパスワードリセットリンクが存在すること"
  end
end
