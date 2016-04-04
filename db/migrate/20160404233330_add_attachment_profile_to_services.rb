class AddAttachmentProfileToServices < ActiveRecord::Migration
  def self.up
    change_table :services do |t|
      t.attachment :profile
    end
  end

  def self.down
    remove_attachment :services, :profile
  end
end
