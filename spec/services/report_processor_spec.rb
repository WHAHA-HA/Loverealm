require 'rails_helper'

RSpec.describe ReportProcessor do
  describe '#initialize' do
    it 'assigns @report' do
      report = Report.new
      report_processor = ReportProcessor.new report
      expect(report_processor.instance_variable_get('@report')).to eq(report)
    end
  end

  describe '#process' do
    it 'comment target' do
      report = FactoryGirl.create(:comment_report)
      result = ReportProcessor.new(report).process
      expect(result).to be true
      expect(report.reload.target).to be nil
    end

    it 'content target' do
      report = FactoryGirl.create(:status_report)
      result = ReportProcessor.new(report).process
      expect(result).to be true
      expect(report.reload.target).to be nil
    end

    it 'user target' do
      role = Role.create name: :banned
      report = FactoryGirl.create(:user_report)
      result = ReportProcessor.new(report).process
      expect(result).to be true
      expect(report.reload.target.role).to eq(role)
    end
  end
end
