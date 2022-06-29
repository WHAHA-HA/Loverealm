class Share < ActiveRecord::Base
  belongs_to :content, counter_cache: true
  belongs_to :user

  after_save :notify_share

  private

  def notify_share
    PubSub::Publisher.new(self.content, 'share', self.user).publish
  end
end
