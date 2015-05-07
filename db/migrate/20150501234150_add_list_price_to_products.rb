class AddListPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :list_price, :string
  end
end
