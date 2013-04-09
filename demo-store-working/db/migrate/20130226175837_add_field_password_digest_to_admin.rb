class AddFieldPasswordDigestToAdmin < ActiveRecord::Migration
  def change
    remove_column :admins, :password_salt
    rename_column :admins, :password_hash, :password_digest
  end
end
