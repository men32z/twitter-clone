require 'rails_helper'

RSpec.describe 'Follow', type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  describe 'following list' do
    before(:each) do
      Follow.create(user_id: user.id, follow_id: user2.id)
      Follow.create(user_id: user2.id, follow_id: user.id)
      visit new_user_session_path
      within 'form' do
        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password
      end
      click_button 'Log in'
      visit following_path(username: user.username)
    end

    scenario "should show the list of users I'm following" do
      expect(page).to have_content(user2.name)
      expect(page).to have_selector("a[href='#{user_profile_path(user2.username)}']")
    end

    scenario 'should show the list in alphabeticall order' do
      user3.name = 'Antonio'
      user3.save
      Follow.create(user_id: user.id, follow_id: user3.id)
      user2.name = 'Banderas'
      user2.save
      visit following_path(username: user.username)
      expect(page.text.tr("\n", '')).to match(/#{user3.name}(.*)#{user2.name}/)
    end

    scenario 'the list must have maximum of 10 users per page.' do
      all_users = []
      15.times do |_x|
        temp_user = create(:user)
        Follow.create(user_id: user.id, follow_id: temp_user.id)
        all_users.push temp_user.name
      end
      all_users = all_users.sort
      visit following_path(username: user.username)
      expect(page).to have_content(all_users[0])
      expect(page).to_not have_content(all_users[11])
    end

    scenario 'list of users should have the correct format' do
      expect(page.text.tr("\n", '')).to match(/#{user2.name} \(@#{user2.username}\)/)
    end
  end

  describe 'followers list' do
    before(:each) do
      Follow.create(user_id: user.id, follow_id: user2.id)
      Follow.create(user_id: user2.id, follow_id: user.id)
      visit new_user_session_path
      within 'form' do
        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password
      end
      click_button 'Log in'
      visit followers_path(username: user.username)
    end

    scenario 'should show the list of followers' do
      expect(page).to have_content(user2.name)
      expect(page).to have_selector("a[href='#{user_profile_path(user2.username)}']")
    end

    scenario 'should show the list in alphabeticall order' do
      user3.name = 'Antonio'
      user3.save
      Follow.create(user_id: user3.id, follow_id: user.id)
      user2.name = 'Banderas'
      user2.save
      visit followers_path(username: user.username)
      expect(page.text.tr("\n", '')).to match(/#{user3.name}(.*)#{user2.name}/)
    end

    scenario "should show a button to follow people who I don't follow" do
      Follow.create(user_id: user3.id, follow_id: user.id)
      visit followers_path(username: user.username)
      expect(page).to have_content(user3.username)
      follow_path_r = follow_path(username: user.username, user_id: user3.id)
      expect(page).to have_selector("a[href='#{follow_path_r}'][data-method='post']")
    end

    scenario "shouldn't show a button to follow people who I follow" do
      expect(page).to have_content(user2.username)
      f_path = follow_path(username: user.username, user_id: user2.id)
      expect(page).to_not have_selector("a[href='#{f_path}'][data-method='post']")
    end

    scenario 'the list must have maximum of 10 users per page.' do
      all_users = []
      15.times do |_x|
        temp_user = create(:user)
        Follow.create(user_id: temp_user.id, follow_id: user.id)
        all_users.push temp_user.name
      end
      all_users = all_users.sort
      visit followers_path(username: user.username)
      expect(page).to have_content(all_users[0])
      expect(page).to_not have_content(all_users[11])
    end

    scenario 'list of users should have the correct format' do
      expect(page.text.tr("\n", '')).to match(/#{user2.name} \(@#{user2.username}\)/)
    end

    scenario 'if I press follow, that user should be in my following list.' do
      Follow.create(user_id: user3.id, follow_id: user.id)
      visit followers_path(username: user.username)
      find(:xpath, "//a[@href='#{follow_path(username: user.username, user_id: user3.id)}']").click
      expect(user.following.map { |x| x.follow.id }.find { |x| x == user3.id }).to eq(user3.id)
    end
    scenario "press follow should redirect me to their profile. and alert that i'm now following that user" do
      Follow.create(user_id: user3.id, follow_id: user.id)
      visit followers_path(username: user.username)
      find(:xpath, "//a[@href='#{follow_path(username: user.username, user_id: user3.id)}']").click
      expect(page.current_path).to eq(user_profile_path(username: user3.username))
      expect(page).to have_content "you are now following #{user3.username}"
    end

    scenario 'fake user should redirect to followers_path' do
      temp_user = create(:user)
      Follow.create(user_id: temp_user.id, follow_id: user.id)
      visit followers_path(username: user.username)
      Follow.where(user_id: temp_user.id, follow_id: user.id).first.delete
      temp_user.delete
      find(:xpath, "//a[@href='#{follow_path(username: user.username, user_id: temp_user.id)}']").click
      expect(page.current_path).to eq(followers_path(username: user.username))
      expect(page).to have_content 'Some errors'
    end
  end

  describe 'profile user tweets list' do
    before(:each) do
      Follow.create(user_id: user.id, follow_id: user2.id)
      Follow.create(user_id: user2.id, follow_id: user.id)
      visit new_user_session_path
      within 'form' do
        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password
      end
      click_button 'Log in'
    end

    scenario 'should show tweets in profile of some user I follow.' do
      message = 'hola mundo'
      user2.posts.create(message: message)
      visit user_profile_path(username: user2.username)
      expect(page).to have_content(message)
    end

    scenario 'should show tweets in order, most recent first' do
      message = 'hola mundo'
      post1 = user2.posts.create(message: "#{message} 1")
      post2 = user2.posts.create(message: "#{message} 2")
      visit user_profile_path(username: user2.username)
      expect(page.text.tr("\n", '')).to match(/#{post2.message}.*#{post1.message}/)
    end
    scenario 'should show pagination with maximum 10 tweets per page.' do
      message = 'hola mundo'
      all_posts = []
      15.times do |x|
        all_posts.push user2.posts.create(message: "#{message} #{x}")
      end
      visit user_profile_path(username: user2.username)
      expect(page).to have_content(all_posts[14].message)
      expect(page).to_not have_content(all_posts[4].message)
    end
    scenario 'should show followers and following' do
      visit user_profile_path(username: user2.username)
      expect(page).to have_content("Followers #{user2.followers_counter}")
      expect(page).to have_content("Following #{user2.following_counter}")
    end
    scenario 'should show profile info' do
      visit user_profile_path(username: user2.username)
      expect(page).to have_content(user2.name)
      expect(page).to have_content(user2.username)
    end
    scenario "should be able to follow from their profile if i'm not doing it." do
      visit user_profile_path(username: user3.username)
      f_path = follow_path(username: user.username, user_id: user3.id)
      expect(page).to have_selector("a[href='#{f_path}'][data-method='post']")
      find(:xpath, "//a[@href='#{f_path}']").click
      expect(page).to_not have_selector("a[href='#{f_path}'][data-method='post']")
    end
  end

  describe 'all users list to follow' do
    before(:each) do
      Follow.create(user_id: user.id, follow_id: user2.id)
      Follow.create(user_id: user2.id, follow_id: user.id)
      visit new_user_session_path
      within 'form' do
        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password
      end
      click_button 'Log in'
    end
    scenario 'should show a list of users to follow.' do
      name = user3.name
      visit users_path
      expect(page).to have_content('Users')
      expect(page).to have_content(name)
    end
  end
end
