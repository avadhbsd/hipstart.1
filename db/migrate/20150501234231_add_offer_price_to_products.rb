class AddOfferPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :offer_price, :string
  end
end
