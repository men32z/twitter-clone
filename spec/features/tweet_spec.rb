require 'rails_helper'

RSpec.describe 'Tweets', type: :feature do
  let(:user) { create(:user) }

  describe 'should redirect when' do
    scenario 'users are not logged' do
      visit new_posts_path
      expect(page.current_path).to eq(new_user_session_path)
    end
  end

  describe 'create tweets' do
    before(:each) do
      visit new_user_session_path
      within 'form' do
        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password
      end
      click_button 'Log in'
    end

    scenario 'show Tweet link in homepage' do
      visit root_path
      expect(page).to have_content('Tweet')
      expect(page).to have_selector("a[href='#{new_posts_path}']")
    end

    scenario 'post a tweet successfully' do
      visit new_posts_path
      message = 'this is a message'
      expect do
        within 'form' do
          fill_in 'Message', with: message
        end
        click_button 'tweet'
      end.to change(Post, :count).by(1)
      expect(page).to have_content('Tweet created')
      expect(page).to have_content(message)
    end

    scenario 'tweet with errors' do
      visit new_posts_path
      expect do
        within 'form' do
          fill_in 'Message', with: ('a' * 280) + 'a'
        end
        click_button 'tweet'
      end.to change(Post, :count).by(0)
      expect(page).to have_content('Message is too long')
    end
  end
end
