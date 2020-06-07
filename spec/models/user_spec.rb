require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations User' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_uniqueness_of(:username) }

    it { is_expected.to have_many(:followers) }
    it { is_expected.to have_many(:following) }
    it { is_expected.to have_many(:posts) }

    it 'should work with factory.' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end
  end

  describe 'model functions' do
    let(:user1) { FactoryBot.create(:user) }
    let(:user2) { FactoryBot.create(:user) }

    it 'has a counter function which returns followers' do
      Follow.create(user_id: user1.id, follow_id: user2.id)
      expect(user1.following_counter).to eq(1)
    end

    it 'has a counter function which returns following' do
      Follow.create(user_id: user2.id, follow_id: user1.id)
      expect(user1.followers_counter).to eq(1)
    end

    it 'tells if is follower with the function follower?' do
      Follow.create(user_id: user2.id, follow_id: user1.id)
      expect(user1.follower?(user2.id)).to be_truthy
      expect(user2.follower?(user1.id)).to_not be_truthy
    end

    it 'tells if is follower with the function following?' do
      Follow.create(user_id: user1.id, follow_id: user2.id)
      expect(user1.following?(user2.id)).to be_truthy
      expect(user2.following?(user1.id)).to_not be_truthy
    end
  end
end
