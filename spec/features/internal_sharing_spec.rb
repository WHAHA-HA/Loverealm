require 'rails_helper'

feature 'Internal Sharing' do
  let(:user) { FactoryGirl.create(:user) }
  let(:content) { FactoryGirl.create(:status, user: FactoryGirl.create(:user)) }

  before do
    login_as(user, scope: :user)

    WebMock.disable_net_connect!(allow_localhost: true)
  end

  scenario 'user can share content', js: true do
    # check if uesr is able to share content
    visit dashboard_content_path(content)
    within "[data-content-id=\"#{content.id}\"]" do
      find(:css, '.share-button-container').click
      expect(find(:css, 'ul.dropdown-menu')).to be_visible
      expect(page).to have_text 'Share on loverealm'
      find(:css, 'li.internal-sharing a').click
      wait_for_ajax
      expect(find(:css, '.shares-count').text).to eq '1'
    end

    # check if shared content appears on dashboard
    visit dashboard_user_path(user)

    expect(page).to have_text "#{user.full_name} shared #{content.user.full_name}'s status"

    within "[data-content-id=\"#{content.id}\"]" do
      find(:css, '.share-button-container').click
      expect(page).to have_text 'Stop sharing on Loverealm'

      # check if user is able to cancel sharing
      find(:css, 'li.internal-sharing a').click
      wait_for_ajax
      expect(find(:css, '.shares-count').text).to eq '0'
    end

    # reload page and check if user's newsletter is empty
    visit dashboard_user_path(user)

    expect(find(:css, '#contents').text).to eq ''
  end
end
