namespace :rabbitmq do
  desc "Setup Comment Subject routing"
  task :setup_comment do
    require "bunny"
    conn = Bunny.new(ENV['RABBIT_AMQP'])
    conn.start

    ch = conn.create_channel

    # get or create exchange
    x = ch.fanout("notification.comment.broadcast")

    # get or create queue (note the durable setting)
    queue = ch.queue("notification.comment.subscribe", durable: true)

    # bind queue to exchange
    queue.bind("notification.comment.broadcast")

    conn.close
  end
  desc "Setup Relationship Subject routing"
  task :setup_relationship do
    require "bunny"
    conn = Bunny.new(ENV['RABBIT_AMQP'])
    conn.start

    ch = conn.create_channel

    # get or create exchange
    x = ch.fanout("notification.relationship.broadcast")

    # get or create queue (note the durable setting)
    queue = ch.queue("notification.relationship.subscribe", durable: true)

    # bind queue to exchange
    queue.bind("notification.relationship.broadcast")

    conn.close
  end

  desc "Setup Content Subject routing "
  task :setup_content do
    require "bunny"
    conn = Bunny.new(ENV['RABBIT_AMQP'])
    conn.start

    ch = conn.create_channel

    # get or create exchange
    x = ch.fanout("notification.content.broadcast")

    # get or create queue (note the durable setting)
    queue = ch.queue("notification.content.subscribe", durable: true)

    # bind queue to exchange
    queue.bind("notification.content.broadcast")

    conn.close
  end


  desc "Setup Message Subject routing "
  task :setup_message do
    require "bunny"
    conn = Bunny.new(ENV['RABBIT_AMQP'])
    conn.start

    ch = conn.create_channel

    # get or create exchange
    x = ch.fanout("notification.message.broadcast")

    # get or create queue (note the durable setting)
    queue = ch.queue("notification.message.subscribe", durable: true)

    # bind queue to exchange
    queue.bind("notification.message.broadcast")

    conn.close
  end

  task :setup => [:setup_message, :setup_content, :setup_comment, :setup_relationship]
end