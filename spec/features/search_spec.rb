require 'rails_helper'

feature 'Search' do
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user, scope: :user)

    @search_user = FactoryGirl.build(:user).tap do |u|
      u.first_name = 'Some'
      u.last_name = 'Name'
      u.save
    end

    @search_status = FactoryGirl.build(:story).tap do |s|
      s.description = 'User story'
      s.save
    end

    FactoryGirl.create(:admin)
  end

  scenario 'user get search result page' do
    visit dashboard_user_path(user)

    # Search for user
    search_for 'some'
    expect(current_path).to eq dashboard_search_path

    expect(page).to have_text 'Some Name'

    # Show message that results are empty
    first(:link, 'Stories').click
    expect(page).to have_text 'Sorry, We could not find what you were looking for.'

    # Search for content
    search_for 'story'
    first(:link, 'Stories').click
    expect(page).to have_text 'User story'
  end

  def search_for(query)
    find(:css, '.search-text[name="filter"]').set(query)
    find(:css, 'form.search-form button').click
  end
end
