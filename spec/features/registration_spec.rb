require 'rails_helper'

feature 'Registration' do
  scenario 'user successfully passes registration' do
    visit new_user_registration_path

    expect(current_path).to eq new_user_registration_path

    submit_registration

    expect(page).to have_text 'Email can\'t be blank'

    fill_in 'user_email', with: 'test@loverealm.com'
    submit_registration

    expect(page).to have_text 'Password can\'t be blank'

    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmations', with: 'password'
    submit_registration

    expect(current_path).to eq root_path
    expect(page).to have_text 'A message with a confirmation link has been sent to your email address.'
  end

  def submit_registration
    click_button 'Create account'
  end
end
