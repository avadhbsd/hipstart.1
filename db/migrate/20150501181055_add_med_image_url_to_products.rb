class AddMedImageUrlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :med_image_url, :string
  end
end
