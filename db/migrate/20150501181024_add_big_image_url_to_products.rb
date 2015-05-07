class AddBigImageUrlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :big_image_url, :string
  end
end
