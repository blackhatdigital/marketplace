class AddServiceIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :service_id, :integer
  end
end
