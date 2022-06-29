class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.user = current_user
    if @feedback.save
      redirect_to :back, notice: 'Feedback is sent successfuly'
    else
      redirect_to :back, error: 'Something is went wrong. Try again.'
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:subject, :description)
  end
end
