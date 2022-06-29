class ContentsHashTag < ActiveRecord::Base
  belongs_to :content
  belongs_to :hash_tag

  validates :content, :hash_tag, presence: true
end
