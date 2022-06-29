require 'rails_helper'

feature 'Splash screen' do

  let!(:splash_screen_text) { 'Just one tap away.'}

  scenario 'show splash screen if user uses mobile' do
    page.driver.header('User-Agent', 'Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Mobile Safari/537.36')
    visit root_path

    expect(page).to have_text splash_screen_text

    find(:css, '.splash-screen-close').click

    page.reset!
    visit root_path

    expect(page).not_to have_text splash_screen_text
  end
end
