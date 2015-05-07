class ChangePriceTypeInProducts < ActiveRecord::Migration
  def change
    change_column :products, :price, :string
  end
end
