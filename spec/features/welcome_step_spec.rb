require 'rails_helper'

feature 'Welcome step' do
  let(:user) { FactoryGirl.create(:newbie_user) }

  before do
    login_as(user, scope: :user)

    %w(Love Relationships).each do |name|
      HashTag.create name: name
    end

    2.times do
      FactoryGirl.create(:user_with_content)
    end

    FactoryGirl.create(:admin)

    WebMock.disable_net_connect!(allow_localhost: true)
  end

  scenario 'user successfully passes all three steps', js: true do
    # First step
    visit dashboard_welcome_first_path

    submit_first_step
    expect(page).to have_text 'Select at least 1 hash tag'

    within(:css, '.suggested-hash-tags') do
      check('hash_tag_1')
    end

    fill_in 'tags-without-autocomplete_tag', with: 'customtag,'
    submit_first_step
    expect(current_path).to eq dashboard_welcome_second_path

    # Auto assign following users
    expect(user.following.size).to eq 2

    # Second step
    submit_second_step
    expect(first('#user_first_name-error').text).to eq 'This field is required.'

    fill_in 'user_first_name', with: 'firstname'
    submit_second_step
    expect(first('#user_last_name-error').text).to eq 'This field is required.'

    fill_in 'user_last_name', with: 'lastname'
    submit_second_step
    expect(first('#user_biography-error').text).to eq 'This field is required.'

    fill_in 'user_biography', with: 'Biography'
    submit_second_step

    expect(current_path).to eq dashboard_welcome_third_path

    click_on 'Finish!'
    expect(current_path).to match(/dashboard\/users\/[\d]+/)
  end

  def submit_first_step
    click_button 'Next Step >'
  end

  def submit_second_step
    click_button 'Save'
  end
end
