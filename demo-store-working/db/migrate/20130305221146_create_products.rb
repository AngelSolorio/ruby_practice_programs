class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :inventory
      t.boolean :active
      t.text :tags

      t.timestamps
    end
  end
end
