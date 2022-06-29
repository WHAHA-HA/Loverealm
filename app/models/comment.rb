class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked only: [:create], owner: :user, trackable_type: 'Comment'

  after_create :notify_content_owner
  belongs_to :content, counter_cache: true
  belongs_to :user

  validates :body, presence: true, allow_blank: false
  validates :user, :content, presence: true

  default_scope { order(created_at: :desc) }

  def owner
    user.nick
  end

  private
  def notify_content_owner
    PubSub::Publisher.new(self, 'comment').publish
  end
end
