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

    scenario 'should see my posts and post from peple who I follow' do
      Follow.create(user_id: user.id, follow_id: user2.id)
      message = 'this is a message'
      user2.posts.create(message: "#{message} #{user2.id}")
      user.posts.create(message: "#{message} #{user.id}")
      visit root_path
      expect(page).to have_content("#{message} #{user2.id}")
      expect(page).to have_content("#{message} #{user.id}")
    end

    scenario "shouldn't see post of people who i'm not following" do
      message = 'this is a message'
      user3.posts.create(message: "#{message} #{user3.id}")
      visit root_path
      expect(page).to_not have_content("#{message} #{user3.id}")
    end

    scenario 'should see counter of people who is following me' do
      visit root_path
      expect(page).to have_content("Followers #{user.followers_counter}")
    end

    scenario "should see counter of people who i'm following" do
      visit root_path
      expect(page).to have_content("Following #{user.following_counter}")
    end

    scenario "i must be able to return to home page while I'm anywhere in the app." do
      visit root_path
      expect(page).to have_content('Home')
      expect(page).to_not have_selector("a[href='#{root_path}']")
      visit followers_path(username: user.username)
      expect(page).to have_content('Home')
      expect(page).to_not have_selector("a[href='#{root_path}']")
      visit following_path(username: user.username)
      expect(page).to have_content('Home')
      expect(page).to_not have_selector("a[href='#{root_path}']")
      find(:xpath, "//a[@href='#{destroy_user_session_path}']").click
      expect(page).to have_content('Home')
      expect(page).to_not have_selector("a[href='#{root_path}']")
    end
  end
end
