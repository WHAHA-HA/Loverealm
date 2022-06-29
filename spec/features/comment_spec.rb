require 'rails_helper'

feature 'Comment' do
  let(:user) { FactoryGirl.create(:user) }
  let(:content) { FactoryGirl.create(:status, user: FactoryGirl.create(:user)) }

  before do
    login_as(user, scope: :user)

    1.upto(5) do |number|
      content.comments.create body: "Comment text #{number}", user: user
    end

    WebMock.disable_net_connect!(allow_localhost: true)
  end

  scenario 'user can write & read comments', js: true do
    visit dashboard_content_path(content)

    within "[data-content-id=\"#{content.id}\"]" do
      expect(page).to have_text "Comment text 1"
      expect(page).to have_text "Comment text 5"
      expect(find('.comments').all('.comment').size).to eq 5

      fill_in 'comment_body', with: 'new comment'
      click_on 'Comment'
      wait_for_ajax

      expect(content.comments.first.body).to eq 'new comment'
    end
  end
end
