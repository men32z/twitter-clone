require 'rails_helper'

RSpec.describe 'Home and Feed', type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  describe 'home path redirect' do
    scenario 'user not logged should redirect to log_in' do
      visit root_path
      expect(page.current_path).to eq(new_user_session_path)
    end
  end

  describe 'Home path' do
    before(:each) do
      visit new_user_session_path
      within 'form' do
        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password
      end
      click_button 'Log in'
    end

    scenario 'user logged should see feed ' do
      visit root_path
      expect(page.current_path).to eq(root_path)
    end

    scenario 'feed is visible' do
      message = 'this is a message'
      user.posts.create(message: message)
      visit root_path
      expect(page).to have_content('Recent Tweets')
      expect(page).to have_content(message)
    end

    scenario 'feed should show pagination of just 10 tweets' do
      message = 'this is a message'
      all_messages = []
      15.times do |x|
        msg = "#{message} #{x}"
        user.posts.create(message: msg)
        all_messages.push(msg)
      end
      visit root_path
      expect(page).to have_content(all_messages[14])
      expect(page).to_not have_content(all_messages[4])
    end

    scenario 'feed should be ordered from the most recent to the oldest ' do
      message = 'this is a message'
      all_messages = []
      2.times do |x|
        msg = "#{message} #{x}"
        user.posts.create(message: msg)
        all_messages.push(msg)
      end
      visit root_path
      expect(page.text.tr("\n", '')).to match(/#{all_messages[1]}(.*)#{all_messages[0]}/)
    end

    scenario 'tweets should have correct format' do
      message = 'this is a message'
      post = user.posts.create(message: message)
      visit root_path
      expect(page.text.tr("\n", '')).to match(/#{user.name}.*@#{user.username}.*#{post.created_at}.*#{message}/)
    end
  end
end
