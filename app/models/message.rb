class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :content

  validates_presence_of :body

  scope :unread_messages, -> { where(is_read: false) }
  scope :trashed, -> { where(removed: true) }
  scope :for_conversation, -> (id) {where('conversation_id = ?', id)}

  after_save :notify_receiver

  def remove
    self.removed = true
    self.removed_at = Time.current
    save!
  end

  private
  def notify_receiver
    PubSub::Publisher.new(self, 'message').publish
  end
end
