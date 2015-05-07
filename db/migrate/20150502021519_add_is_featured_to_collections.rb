class AddIsFeaturedToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :is_featured, :boolean
  end
end
