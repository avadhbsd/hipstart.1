class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.decimal :price
      t.string :name
      t.string :brand
      t.references :user, index: true
      t.boolean :is_published
      t.references :collection, index: true
      t.string :asin
      t.string :author

      t.timestamps
    end
  end
end
