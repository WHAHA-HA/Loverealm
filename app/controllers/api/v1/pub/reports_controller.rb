class Api::V1::Pub::ReportsController < Api::V1::BaseController
  def create
    @report = Report.new(report_params.merge(user_id: current_user.id))

    if @report.save
      render(:show, status: :created) && return
    else
      render(json: { errors: @report.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  private

  def report_params
    params.permit(:description, :target_type, :target_id).tap do |data|
      data[:target_type].capitalize!
    end
  end
end
