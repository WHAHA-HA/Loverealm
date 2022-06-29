class Dashboard::MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :set_conversation, only: [:create]

  respond_to :html, :js

  def index
    @message = Message.new
    @messages = current_user.get_list_of_messages
    respond_with(@messages)
  end

  def show
    respond_with(@message)
  end

  def new
    @receiver = User.find(params[:receiver_id]) if params[:receiver_id].present?

    @message = Message.new
    respond_to :js
  end

  def edit
  end

  def create
    return redirect_to :back, flash: { error: 'Please pick receiver from dropdown list' } if @conversation.nil?
    @message = @conversation.messages.new(message_params)
    @message.sender = current_user
    @message.receiver_id = @conversation.get_participant(current_user)
    @message.save
    respond_to :js
    # if @message.save
    #   respond_to do |format|
    #     format.html {redirect_to :back, notice: 'Message sent successfully.'}
    #     format.js {render template: 'dashboard/conversations/create', format: 'js'}
    #   end
    # else
    #   respond_to do |format|
    #     format.html {redirect_to :back, flash: { error: @message.errors.full_messages[0].to_s }}
    #     format.js {render template: 'dashboard/conversations/create', format: 'js' }
    #   end
    # end
  end

  def search_receiver
    @users = current_user.search_following(params[:search], 1, 10)
    render json: @users
  end

  def update
    @message.update(message_params)
    respond_with(@message)
  end

  def destroy
    @message.remove
    redirect_to :back
  end

  def trashed
    @messages = current_user.sent_messages.trashed
    render 'dashboard/conversations/trashed'
  end

  def retrieve_message
    @message = Message.find(params[:id])
    @message.update_attribute(:removed, false)
    redirect_to :back
  end

  def conversations
    @message = Message.new
    @user = User.find params[:user_id]
    @messages = current_user.get_conversation_with(params[:user_id])
    @messages = @messages.order('created_at')
  end

  private

  def set_conversation
    if params[:conversation_id]
      @conversation = Conversation.find(params[:conversation_id])
    elsif Conversation.between(current_user.id, message_params[:receiver_id]).present?
      @conversation = Conversation.between(current_user.id, message_params[:receiver_id]).take
    else
      if message_params[:receiver_id].present?
        @conversation = Conversation.create!(participants: [current_user.id, message_params[:receiver_id]])
      end
    end
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:subject, :body, :receiver_id)
  end
end
