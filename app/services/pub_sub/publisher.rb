require_relative '../pub_queue/publisher'

module PubSub
  class Publisher

    def initialize entity, type="", user=nil
      @payload = { type: type, source: entity }
      case type
        when 'follow'
          @channel = 'relationship'
          @payload[:user] = user || entity.follower
        when 'comment'
          @channel = 'comment'
          @payload[:user] = user || entity.user
        when 'share'
          @channel = 'content'
          @payload[:user] = user || entity.user
        when 'message'
          @channel = 'message'
          @payload[:user] = user || entity.sender
        when 'like'
          @channel = 'content'
          @payload[:user] = user
      end
    end

    def publish
      Delayed::Worker.logger.debug("Publisher start")
      broadcast
      Delayed::Worker.logger.debug("Publisher end")
    end

    private
    def broadcast
      message = { :data => @payload, ext: { auth_token: Rails.application.config.faye_token }}
      PubQueue::Publisher.publish("#{@channel}.broadcast", message)
    end

  end
end



