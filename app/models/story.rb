class Story < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :likes

  has_attached_file :image,
                    styles: {
                      medium: '400x400'
                    },
                    convert_options: {
                      full: '-quality 40',
                      thumb: '-quality 40'
                    }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :image, less_than: 4.megabytes

  validates_presence_of :body
end
