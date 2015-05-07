class PagesController < ApplicationController
  
  
  def index
    
    @products = Product.last(3)
    
    @featured_collections = Collection.where(:is_featured => true)
    

  end
  
end