class Api::V1::Pub::MessagesController < Api::V1::BaseController
  def create
    receiver = User.find(message_params[:receiver_id])

    unless @conversation = Conversation.between(current_user.id, receiver.id).take
      @conversation = Conversation.create!(participants: [current_user.id, receiver.id])
    end

    @message = @conversation.messages.new(message_params.merge(sender_id: current_user.id))

    if @message.save
      render(:show, status: :created) && return
    else
      render(json: { errors: @message.errors.full_messages }, status: :unprocessable_entity) && return
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.remove

    head(:no_content) and return
  end

  def deleted
    @number_of_messages = Message.trashed.count
    @messages = Message.trashed.page(params[:page]).per(params[:per_page])

    render :index
  end

  private
  def message_params
    params.permit(:body, :receiver_id)
  end
end
