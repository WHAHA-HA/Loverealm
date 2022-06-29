class Dashboard::ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access_if_not_participant, only: [:show]
  respond_to :html, :json

  def index
    @conversations = current_user.my_conversations.recent
                                 .page(params[:page]).per(20)
    @message = Message.new
  end

  def show
    @messages = @conversation.messages.order('created_at')
    @message = Message.new
    current_user.check_unread_messages(@conversation)
  end

  def chat_list
    @conversations = current_user.my_conversations.recent
                                .page(params[:page]).per(20)
  end

  def read_messages
    @conversation = Conversation.find(params[:id])
    if @conversation
      current_user.check_unread_messages(@conversation)
    end

    respond_to :json
  end

  private
  def restrict_access_if_not_participant
    @conversation = Conversation.where("id = ? AND ? = ANY(participants)", params[:id], current_user.id).take
    if !@conversation.present?
      flash[:error] = 'You are not authorized to see this conversation!'
      redirect_to dashboard_user_conversations_path(current_user)
    end
  end
end
