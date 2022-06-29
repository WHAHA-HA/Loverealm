class User < ActiveRecord::Base
  include PublicActivity::Model
  include PgSearch

  has_many :contents
  has_many :shared_contents, through: :shares, source: :content
  has_many :shares
  has_many :identities, dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy
  has_many :active_relationships, class_name:  'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :feedbacks
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_and_belongs_to_many :hash_tags
  has_many :content_hash_tags, -> { group('hash_tags.id').order("COUNT('hash_tags.id') DESC") }, through: :contents, source: :hash_tags
  has_many :mobile_tokens

  belongs_to :role

  has_one :mentorship, foreign_key: :mentor_id
  has_one :mentorship_hash_tag, through: :mentorship, source: :hash_tag

  has_many :mentors_appointments, class_name: 'Appointment', foreign_key: 'mentor_id'
  has_many :mentee_appointments, class_name: 'Appointment', foreign_key: 'mentee_id'

  acts_as_voter

  SEX = [
    { id: 0, value: 'Male' },
    { id: 1, value: 'Female' }
  ].freeze

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :confirmable, :lastseenable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :twitter]

  has_attached_file :avatar,
                    s3_credentials: File.join(Rails.root, 'config', 's3.yml'),
                    s3_host_name: 's3-eu-west-1.amazonaws.com',
                    path: '/:class/:attachment/:id_partition/:style/:filename',
                    url: ':s3_domain_url',
                    styles: {
                      small: '50x50>',
                      thumb: '100x100>',
                      square: '200x200#',
                      medium: '300x300>'
                    },
                    convert_options: {
                      medium: '-quality 80 -interlace Plane',
                      thumb: '-quality 80 -interlace Plane'
                    },
                    default_url: 'missing.jpg'

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :avatar, less_than: 2.megabytes

  has_attached_file :cover,
                    s3_credentials: File.join(Rails.root, 'config', 's3.yml'),
                    s3_host_name: 's3-eu-west-1.amazonaws.com',
                    path: '/:class/:attachment/:id_partition/:style/:filename',
                    url: ':s3_domain_url',
                    styles: { medium: '498x160#' },
                    convert_options: {
                      medium: '-quality 80 -interlace Plane'
                    },
                    default_url: 'default-cover.jpg'

  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :cover, less_than: 2.megabytes

  validates_uniqueness_of :email, on: :create

  validates_presence_of :email
  validates_presence_of :first_name, :last_name, :biography, if: :update_profile_details?

  validates :password, presence: true, confirmation: true, on: :create
  # validates :password, presence: true, :confirmation => true, :on => :update

  pg_search_scope :search_by_full_name,
                against: [:first_name, :last_name],
                using: {
                  :tsearch => {
                    :dictionary => 'english',
                    :tsvector_column => 'tsv'
                  },
                  trigram: {
                    :threshold => 0.1
                  }
                }

  attr_accessor :upload_profile_avatar

  after_validation :clean_paperclip_errors
  before_create :set_default_role

  scope :online, -> { where('users.last_seen >= ?', Time.now - 15.minutes) }
  scope :banned, -> { joins(:role).where('users.role_id = ?', Role.find_by_name('banned').id) }
  scope :completed_users, -> { where.not(is_newbie: true) }
  scope :with_full_profile, -> { where.not('first_name is NULL or last_name is NULL or avatar_file_name is NULL') }
  scope :all_mentors, -> { joins(:role).where('users.role_id = ?', Role.find_by_name('mentor').id) }
  scope :get_mentors_by_hash_tags, -> (tags) { joins(:mentorship_hash_tags).where('hash_tags.id IN (?)', tags) }
  scope :admins, -> { joins(:role).where('users.role_id = ?', Role.find_or_create_by(name: 'admin').id) }


  def self.newsletter_subscribers
    where(receive_notification: true)
  end

  def self.default_mentor
    admins.take
  end

  def clean_paperclip_errors
    errors.delete(:avatar)
  end

  def update_profile_details?
    persisted? && !upload_profile_avatar
  end

  def password_matching
    if password != password_confirmations
      errors.add(:password_confirmations, "doesn't match")
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def check_unread_messages conversation
    self.received_messages.for_conversation(conversation.id).update_all(is_read: true)
  end
  def display_sex
    SEX.select { |sex| [sex[:id], sex[:value]] }
  end

  def my_conversations
    Conversation.where('? = ANY (participants)', id)
  end

  def get_list_of_messages
    array = []
    Message.where('sender_id = ? or receiver_id = ?', id, id).order('created_at DESC')
           .select do |m|
      array << if m.sender_id != id
                 { sender: m.sender_id }
               else
                 { receiver: m.receiver_id }
               end
    end
    array = array.uniq(&:values)
  end

  def get_short_list_of_messages
    array = []
    Message.unread_messages.where('sender_id = ? or receiver_id = ?', id, id).order('created_at DESC').limit(3)
           .select do |m|
      array << if m.sender_id != id
                 { sender: m.sender_id }
               else
                 { receiver: m.receiver_id }
               end
    end
    array = array.uniq(&:values)
  end

  def unread_messages_count
    @unread_messages_count ||= received_messages.where(is_read: false).count
  end

  def get_conversation_with(user_id)
    Message.where('(sender_id = ? and receiver_id = ?) or (sender_id = ? and receiver_id = ?)', id, user_id, user_id, id)
  end

  def self.create_from_omniauth(auth)
    unless user = find_by(email: auth.info.email)
      temp_password = Devise.friendly_token[0, 20]
      user = self.new(email: auth.info.email, password: temp_password, password_confirmations: temp_password,
        first_name: auth.info.first_name, last_name: auth.info.last_name)
      user.skip_confirmation!
      user.save
    end

    Identity.find_or_create_from_omniauth(user, auth)

    user
  end

  def require_password?
    identities.empty?
  end

  # Roles
  def admin?
    role_id == Role.find_or_create_by(name: 'admin').id
  end

  def banned?
    role_id == Role.find_or_create_by(name: 'banned').id
  end
  # end roles

  def my_contents
    Content.where(user_id: id).where.not(content_type: 'daily_story').order('created_at desc')
  end

  def see_contacts(another_user)
    following.include? another_user
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def num_of_followers
    if ['yaw@loverealm.org', 'sparklinguy2002@yahoo.com'].include? self.email
      followers.count + 21234
    else
      followers.count
    end
  end

  def avatar_url
    avatar.url
  end

  def unread_notifications
    Notification.for_user(self)
                .where('activities.created_at > ?', notifications_checked_at)
  end

  def unread_notification_count
    unread_notifications.count
  end

  def crypted_hash
    Base64.encode64(id.to_s).gsub(/[^a-zA-Z0-9\-]/,"")
  end

  def access_token
    User.verifier.generate [id, 1.week.from_now]
  end

  def self.verifier
    ActiveSupport::MessageVerifier.new Rails.application.secrets[:secret_key_base]
  end

  def self.find_by_access_token signature
    id, time = verifier.verify(signature)
    User.find(id) if time > Time.now
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  def set_default_role
    self.role = Role.find_by_name('users')
  end

  def set_image(attribute, image_params)
    image = Paperclip.io_adapters.for(image_params[:base64_data])
    image.original_filename = image_params[:original_filename]
    send("#{attribute}=", image)
  end

  def self.search(query, options = {})
    # sql = "CONCAT(LOWER(first_name), ' ', LOWER(last_name)) like :query"
    # sql = "#{sql} OR LOWER(email) like :query" if options[:email]
    # where(sql, query: "%#{query.downcase.strip}%")
    search_by_full_name(query.downcase.strip)
  end

  def search_following(search_term, page, per_page)
    self.following.
      where('LOWER(first_name) like ? OR LOWER(last_name) like ? OR LOWER(email) like ?', "%#{search_term.downcase}%", "%#{search_term.downcase}%", "%#{search_term.downcase}%").
      page(page).per(per_page)
  end

  def self.suggested_users(user)
    select('users.*, COUNT(contents.id) * greatest(COUNT(htu.hash_tag_id), 1) AS weight')
      .joins(sanitize_sql_array([
                                  'LEFT JOIN hash_tags_users as htu ON htu.user_id = users.id AND htu.hash_tag_id IN (?)',
                                  user.hash_tags.pluck(:id)
                                ]))
      .joins(sanitize_sql_array([
                                  'LEFT JOIN relationships as r ON r.followed_id = users.id AND r.follower_id = ?',
                                  user.id
                                ]))
      .joins(:contents)
      .where('r.id IS NULL AND users.id <> ?', user.id)
      .completed_users.with_full_profile
      .group('users.id').order('weight DESC')
  end

  def as_json(options)
    super(options.merge(
      methods: [:avatar_url]
    ))
  end
end
