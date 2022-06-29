class Api::V1::Pub::ConversationsController < Api::V1::BaseController
  def index
    @conversations = current_user.my_conversations.recent
                                 .page(params[:page]).per(params[:per_page])
  end

  def read_messages
    @conversation = Conversation.find(params[:id])
    if @conversation
      user = current_user
      user.check_unread_messages(@conversation)
    end
    render json: {}, status: :ok
  end

  def unread_message_count
    @conversation = Conversation.find(params[:id])
    if @conversation
      user = current_user
      render json: {count: user.received_messages.for_conversation(@conversation.id).unread_messages.count}
    else
      render json: {count: 0}
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.page(params[:page]).per(params[:per_page]).order('messages.updated_at DESC').to_a
    current_user.check_unread_messages(@conversation)
  end
end
