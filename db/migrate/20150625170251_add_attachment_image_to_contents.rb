class AddAttachmentImageToContents < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :contents, :image
  end
end
