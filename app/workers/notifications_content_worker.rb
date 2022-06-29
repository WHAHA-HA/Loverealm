require_relative '../../lib/notification/notification_subject'

class NotificationsContentWorker
  include Sneakers::Worker
  include NotificationSubject

  # This worker will connect to "notification.content" queue
  from_queue "notification.content.subscribe", env: nil

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to RecentPosts service without
  # changes


  def work(raw_post)
    broadcast(raw_post)
    ack! # we need to let queue know that message was received
  end
end

