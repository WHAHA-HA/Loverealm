class Api::V1::Pub::DashboardController < Api::V1::BaseController
  def show
    @contents = NewsfeedService.new(current_user).recent_content
    @contents = @contents.page(params[:page])
                         .per(params[:per_page])
                         .includes(:hash_tags, :user)
  end
end
