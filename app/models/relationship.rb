class Relationship < ActiveRecord::Base
  include PublicActivity::Model
  tracked only: [:create], owner: :followed, recipient: :follower, trackable_type: 'Relationship'
  after_save :notify_following_user

  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  # Create activity for relation type only once per day
  def create_activity(*args)
    options = prepare_settings(*args)
    options = options.slice(:trackable_type, :key, :owner, :recipient)
    unless PublicActivity::ORM::ActiveRecord::Activity.where(options)
                                                      .where('created_at >= ?', Time.zone.now.beginning_of_day).exists?
      super(*args)
    end
  end

  private
  def notify_following_user
    PubSub::Publisher.new(self, 'follow').publish
  end
end
