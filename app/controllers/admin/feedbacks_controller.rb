module Admin
  class FeedbacksController < BaseController
    def index
      @feedbacks = Feedback.unchecked.page(params[:page])
    end

    def show
      @feedback = Feedback.find(params[:id])
    end
  end
end
