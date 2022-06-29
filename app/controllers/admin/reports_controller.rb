module Admin
  class ReportsController < BaseController
    before_filter :load_report, except: :index

    def index
      @reports = Report.includes(:target).page(params[:page]).per(10)
    end

    def show
    end

    def reviewed
      @report.update(reviewed: true)
      redirect_to admin_reports_path, notice: 'Report successfully updated.'
    end

    def process_report
      processor = ReportProcessor.new(@report)
      if processor.process
        redirect_to admin_reports_path, notice: 'Report successfully processed.'
      else
        redirect_to :back, error: 'Something went wrong. Try again.'
      end
    end

    private

    def load_report
      @report = Report.find(params[:id])
    end
  end
end
