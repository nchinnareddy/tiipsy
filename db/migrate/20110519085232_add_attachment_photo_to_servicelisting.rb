class AddAttachmentPhotoToServicelisting < ActiveRecord::Migration
  def self.up
    add_column :servicelistings, :photo_file_name, :string
    add_column :servicelistings, :photo_content_type, :string
    add_column :servicelistings, :photo_file_size, :integer
    add_column :servicelistings, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :servicelistings, :photo_file_name
    remove_column :servicelistings, :photo_content_type
    remove_column :servicelistings, :photo_file_size
    remove_column :servicelistings, :photo_updated_at
  end
end
