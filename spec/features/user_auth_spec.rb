require 'rails_helper'

RSpec.describe 'User Auth', type: :feature do
  let(:user) { create(:user) }

  describe 'User sign up' do
    before(:each) do
      visit new_user_registration_path
    end

    scenario 'User registered successfully' do
      within 'form' do
        fill_in 'Name', with: 'Mike Wazowsky'
        fill_in 'Username', with: 'wazowsky32'
        fill_in 'Email', with: 'mike@monsterinc.com'
        fill_in 'Password', with: '123123'
        fill_in 'Password confirmation', with: '123123'
      end
      click_button 'Sign up'
      expect(page).to have_content('wazowsky32')
    end

    scenario 'Invalid info' do
      within 'form' do
        fill_in 'Name', with: 'Mike Wazowsky'
        fill_in 'Username', with: 'wazowsky32'
        fill_in 'Email', with: 'mike'
        fill_in 'Password', with: '123123'
        fill_in 'Password confirmation', with: '123123'
      end
      click_button 'Sign up'
      expect(page).to have_content('Email is invalid')
    end
  end

  describe 'User sign in' do
    before(:each) do
      visit new_user_session_path
    end

    scenario 'User login successfully' do
      within 'form' do
        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password
      end
      click_button 'Log in'
      expect(page).to have_content(user.username)
    end

    scenario 'Invalid info' do
      within 'form' do
        fill_in 'Username', with: 'kakaroto'
        fill_in 'Password', with: 'IloveVeggeta'
        click_button 'Log in'
      end
      expect(page).to have_content('Invalid Username or password')
    end

    scenario 'I must be able to log out' do
      within 'form' do
        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password
      end
      click_button 'Log in'
      find(:xpath, "//a[@href='#{destroy_user_session_path}']").click
      expect(page.current_path).to eq(new_user_session_path)
    end
  end
end
