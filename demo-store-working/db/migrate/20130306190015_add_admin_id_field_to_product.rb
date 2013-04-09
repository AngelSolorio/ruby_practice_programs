class AddAdminIdFieldToProduct < ActiveRecord::Migration
  def change
    add_column :products, :admin_id, :integer
  end
end
