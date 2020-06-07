require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations Post' do
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:user_id) }
    it { is_expected.to belong_to(:user) }
    it { should validate_length_of(:message).is_at_least(1) }
    it { should validate_length_of(:message).is_at_most(280) }

    it 'should work with factory.' do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user: user)
      expect(post).to be_valid
    end
  end
end
