class Dashboard::SearchController < ApplicationController
  before_filter :get_displayed_user

  helper_method :show_users?
  helper_method :show_stories?

  respond_to :json, :html

  def index
    unless params[:filter].present?
      redirect_to :back
      return
    end
    search_users if show_users?
    search_content if show_stories?
  end

  def get_autocomplete_data
    results = {}
    results[:contents] = Content.search(params[:search])
    results[:users] = User.completed_users
                        .search(params[:search], email: true).limit(5)
    respond_with(results)
  end

  private

  def search_content
    @content ||= Content.search(params[:filter]).includes(:hash_tags)
  end

  def search_users
    @users ||= User.completed_users.search(params[:filter])
  end

  def get_displayed_user
    @displayed_user = current_user
  end

  def show_users?
    params[:type] == 'people'
  end

  def show_stories?
    params[:type] == 'stories'
  end
end
