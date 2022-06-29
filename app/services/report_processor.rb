class ReportProcessor
  def initialize(report)
    @report = report
  end

  def strategy
    case @report.target_type
    when 'User' then :ban_user
    when 'Content' then :destroy_content
    when 'Comment' then :destroy_comment
    else
      raise 'Unsupported report type'
    end
  end

  def process
    result = send(strategy)
    @report.update reviewed: true
    result
  end

  private

  def ban_user
    @report.target.role = Role.find_by_name('banned')
    @report.target.save
  end

  def destroy_content
    @report.target.destroy
    @report.target.destroyed?
  end

  alias destroy_comment destroy_content
end
