class Content < ActiveRecord::Base
  include PublicActivity::Model
  include Taggable
  include Popularable
  include Bootsy::Container
  acts_as_votable
  include PgSearch

  before_save :get_hash_tags, unless: :is_story?

  tracked only: [:create], owner: proc { |controller, _model| controller && controller.current_user }, trackable_type: 'Content'

  belongs_to :user
  has_many :comments
  has_many :shares
  has_and_belongs_to_many :hash_tags
  has_many :messages

  # after_create :notify_followers

  has_attached_file :image,
                    s3_credentials: {
                      bucket: ENV['S3_BUCKET'],
                      access_key_id: ENV['AWS_KEY'],
                      secret_access_key: ENV['AWS_SECRET']
                    },
                    s3_host_name: 's3-eu-west-1.amazonaws.com',
                    styles: {
                      medium: '800x800>',
                      full: '800x800>'
                    },
                    convert_options: {
                      medium: '-quality 80 -interlace Plane',
                      thumb: '-quality 80 -interlace Plane'
                    }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :image, less_than: 5.megabytes, more_than: 1.megabyte
  validates_presence_of :description
  validates_presence_of :title, :image, if: :is_story?
  validates_presence_of :publishing_at, if: :is_daily_story?

  validates :description, length: { maximum: 150 },
                          if: proc { |m| %(status image).include?(m.content_type) }

  attr_reader :contain_bad_words

  pg_search_scope :search_by_title_or_description,
                  against: [:title, :description],
                  using: {
                    :tsearch => {
                      :dictionary => 'english',
                      :tsvector_column => 'tsv'
                    },
                    trigram: {
                      :threshold => 0.1
                    }
                  }

  before_save do
    self.description = remove_bad_words(description)

    self.title = remove_bad_words(title) if is_story?
  end

  after_save do
    report 'Contain bad words' if @contain_bad_words
  end

  scope :match_with_hash_tags, -> (hash_tags) { joins(:hash_tags).where('hash_tags.id IN (?)', hash_tags) }
  scope :merging_with_comments, -> (user, content) { joins(:comments).only_stories(user, content) }
  scope :fetch_daily_devotions, -> { where(content_type: 'daily_story') }

  def self.only_stories(user = nil, content = nil)
    query = where(content_type: :story)
    query = query.where.not(user_id: user.id) if user.present?
    query = query.where.not(id: content.id) if content.present?
    query
  end

  def self.recommendations_by_hash_tags(user, content)
    only_stories(user, content)
      .joins(sanitize_sql_array([
                                  'LEFT JOIN contents_hash_tags as cht ON cht.content_id = contents.id AND cht.hash_tag_id IN (?)',
                                  user.present? ? user.hash_tags.pluck(:id) : []
                                ]))
      .select('contents.*, count(cht.hash_tag_id) AS tag_count')
      .group('contents.id').order('tag_count desc')
  end

  def self.recommendations_by_popularity(user=nil, content=nil)
    merging_with_comments(user, content).select('contents.*, count(comments)').group('contents.id').order('cached_votes_up, count(comments) desc')
  end

  def self.filter_by_tags(tag_id)
    joins(:contents_hash_tags)
      .where('contents_hash_tags.hash_tag_id IN (?)', tag_id)
  end

  def is_story?
    content_type == 'story'
  end

  def is_status?
    content_type == 'status'
  end

  def is_picture?
    content_type == 'image'
  end

  def is_daily_story?
    content_type == 'daily_story'
  end

  def is_published?
    is_daily_story? && publishing_at < Time.now
  end

  def content_preview
    description.html_safe
  end

  def is_liked_by?(user)
    user && get_likes.where(voter_id: user.id).take.present?
  end

  def set_image(image_params)
    pimage = Paperclip.io_adapters.for(image_params[:base64_data])
    pimage.original_filename = image_params[:original_filename]
    self.image = pimage
  end

  def report(description = 'System report')
    report = Report.new(description: description,
                        target: self)
    report.save
  end

  def is_shared_by? user
    (self.try(:feed_item_type) == 'share' &&
      self.try(:feed_item_shared_by) == user.id) ||
    Share.where(user: user, content: self).first.present?
  end

  def notify_likes(user)
    PubSub::Publisher.new(self, "like", user).publish
  end

  private

  def get_hash_tags
    self.hash_tags = find_hash_tags
  end

  def remove_bad_words(text)
    text.gsub(/\b\w+\b/) do |word|
      if bad_words_hash[word.downcase]
        @contain_bad_words = true
        '***'
      else
        word
      end
    end.squeeze(' ')
  end

  def bad_words_hash
    @bad_words_hash ||= {}.tap do |bad_hash|
      Word.all.each { |w| bad_hash[w.name] = true }
    end
  end

  def self.search(query)
    where('content_type = ?', 'story').search_by_title_or_description(query)
  end

  # def notify_followers
  #   PubSub::Publisher.new(self).publish
  # end
end
