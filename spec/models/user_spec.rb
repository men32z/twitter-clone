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
end
