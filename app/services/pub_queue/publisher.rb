module PubQueue
  class Publisher
    # In order to publish message we need a exchange name.
    # Note that RabbitMQ does not care about the payload -
    # we will be using JSON-encoded strings

    def self.publish(exchange, message = {})
      # grab the fanout exchange
      Delayed::Worker.logger.debug("notification.#{exchange}")
      x = channel.fanout("notification.#{exchange}")
      # and simply publish message
      x.publish(message.to_json)
    end

    def self.channel
      @channel ||= connection.create_channel
    end

    # We are using default settings here
    # The `Bunny.new(...)` is a place to
    # put any specific RabbitMQ settings
    # like host or port
    def self.connection
      @connection ||= Bunny.new(ENV['RABBIT_AMQP']).tap do |c|
        c.start
      end
    end
  end
end
