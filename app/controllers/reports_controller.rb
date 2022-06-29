class ReportsController < ApplicationController
  before_filter :load_target
  before_action :authenticate_user!

  def new
    @report = Report.new target: @target
  end

  def create
    report = Report.new(report_params)
    report.target = @target
    redirect_to :back, notice: 'Reported user successfully' if report.save
  end

  private

  def report_params
    params.require(:report).permit(:description)
  end

  def target_params
    if params[:report].present?
      params.require(:report).permit(:target_id, :target_type)
    else
      params
    end
  end

  def load_target
    @target ||= begin
      klass = target_params[:target_type].capitalize.constantize
      klass.find(target_params[:target_id])
    end
  end
end
