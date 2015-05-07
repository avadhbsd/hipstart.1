class AddIsFeaturedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_featured, :boolean
  end
end
