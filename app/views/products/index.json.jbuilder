json.array!(@products) do |product|
  json.extract! product, :id, :price, :name, :brand, :user_id, :is_published, :collection_id, :asin, :author
  json.url product_url(product, format: :json)
end
