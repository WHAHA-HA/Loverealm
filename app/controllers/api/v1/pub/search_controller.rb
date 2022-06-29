class Api::V1::Pub::SearchController < Api::V1::BaseController
  def index
    @result = {}
    @result[:contents] = find_contents params[:query]
    @result[:users] = find_users params[:query]
  end

  def by_type
    @type = params[:type]
    unless %w(contents users).include?(@type)
      render_unknown_type_error and return
    end

    @result = send("find_#{@type}", params[:query])
  end

  private

  def find_contents(query)
    Content.search(query)
      .page(params[:page]).per(params[:per_page])
  end

  def find_users(query)
    User.completed_users
        .search(query, email: true)
        .page(params[:page]).per(params[:per_page])
  end

  def render_unknown_type_error
    render json: { errors: [:unknown_type] }, status: :not_found
  end
end
