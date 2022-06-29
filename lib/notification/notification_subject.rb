require 'fcm'
module NotificationSubject
  attr_accessor :subscribers, :channels, :entity
  FAYE_URI = URI.parse(ENV['FAYE_URL'])
  COMMON_CHANNEL = ENV['COMMON_CHANNEL']

  def set_data(raw_data)
    @entity = nil
    @subscribers = []
    @channels = []
    @message = JSON.parse(raw_data)
    @data = @message['data']
    Delayed::Worker.logger.debug(@message)
    # @user = User.new.from_json(@data['user'].to_json)
    @user = User.find(@data['user']['id'])
    case @data['type']
      when "message"
        @entity = Message.new.from_json(@data['source'].to_json)
      when "like"
        @entity = Content.new.from_json(@data['source'].to_json)
      when "share"
        @entity = Content.new.from_json(@data['source'].to_json)
      when "follow"
        @entity = Relationship.new.from_json(@data['source'].to_json)
      when "comment"
        @entity = Comment.new.from_json(@data['source'].to_json)
    end
  end

  def add_subscribers
    type = @data['type']
    case type
      when 'like'
        @subscribers << @entity.user
      when 'share'
        @subscribers << @entity.user
      when 'comment'
        user_ids = @entity.content.comments.collect{ |comment| comment.user_id }
        user_ids <<  @entity.content.user_id
        if user_ids.count > 0
          @subscribers += User.where("id in (?)", user_ids).to_a
        end
      when 'follow'
        @subscribers << @entity.followed
      when 'message'
        @subscribers << @entity.receiver
    end
    @subscribers = @subscribers - [@user]
  end

  def define_channel
    if @data['type'] != 'message'
      @channels << "/notifications/#{ENV['COMMON_CHANNEL']}"
    end
    @subscribers.each do |subscriber|
      @channels << "/notifications/#{subscriber.crypted_hash}"
    end
  end

  def broadcast_mobile
    fcm = FCM.new(ENV['FCM_API_KEY'])
    options = {data: @data, collapse_key: "notification"}
    registration_ids = []
    @subscribers.each do |subscriber|
      registration_ids += subscriber.mobile_tokens.collect{|token| token.fcm_token}
    end
    Delayed::Worker.logger.debug(registration_ids)
    if registration_ids.count > 0
      Delayed::Worker.logger.debug("========sending")
      response = fcm.send(registration_ids, options)
      Delayed::Worker.logger.debug(response)
    end
  end

  def broadcast(raw_post)
    set_data(raw_post)
    add_subscribers
    define_channel
    Delayed::Worker.logger.debug("=========@channels")
    Delayed::Worker.logger.debug(@channels)
    @channels.each do |channel|
      message = { :channel => channel,:data => @data, ext: @message['ext']}
      Delayed::Worker.logger.debug(message)
      Net::HTTP.post_form(FAYE_URI, :message => message.to_json)
    end
    broadcast_mobile
  end
end
