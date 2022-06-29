class Conversation < ActiveRecord::Base
  has_many :messages
  belongs_to :appointment

  scope :between, -> (sender_id, receiver_id) do
    where('participants @> ARRAY[?]',
          [sender_id.to_i, receiver_id.to_i])
  end

  scope :recent, -> do
    joins(:messages)
    .group("conversations.id")
    .order('max(messages.created_at) DESC')
  end

  def get_participant(user)
    participants.delete(user.id)

    participants[0]
  end
end
