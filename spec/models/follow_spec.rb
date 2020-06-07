require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }

  describe 'validations Follows' do
    it { should validate_presence_of(:follow_id) }
    it { should validate_presence_of(:user_id) }
    it { is_expected.to belong_to(:user) }

    it "should create a assosiation with users that doesn't exist" do
      expect do
        Follow.create(user_id: 50_000, follow_id: 50_001)
      end.to change(Follow, :count).by(0)
    end
  end

  describe 'relationships validations' do
    it 'shouldn validate not follow same user_id' do
      expect do
        Follow.create(user_id: user1.id, follow_id: user1.id)
      end.to change(Follow, :count).by(0)
    end

    it 'shouldn validate not follow again' do
      expect do
        Follow.create(user_id: user1.id, follow_id: user2.id)
        Follow.create(user_id: user1.id, follow_id: user2.id)
      end.to change(Follow, :count).by(1)
    end

    it 'shouldn be able to follow and be followed' do
      expect do
        Follow.create(user_id: user1.id, follow_id: user2.id)
        Follow.create(user_id: user2.id, follow_id: user1.id)
      end.to change(Follow, :count).by(2)
    end

    it 'user.following should show people who i Follow' do
      Follow.create(user_id: user1.id, follow_id: user2.id)
      expect(user1.following.last.follow_id).to eq(user2.id)
    end

    it 'user.followers should show people who are following me' do
      Follow.create(user_id: user2.id, follow_id: user1.id)
      expect(user1.followers.last.user_id).to eq(user2.id)
    end
  end
end
