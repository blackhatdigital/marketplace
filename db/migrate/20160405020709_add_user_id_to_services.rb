class AddUserIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :userID, :integer
  end
end
