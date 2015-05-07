class ProductsController < ApplicationController

  #->Prelang (scaffolding:rails/scope_to_user)
  before_filter :require_user_signed_in, only: [:new, :edit, :create, :update, :destroy]

  before_action :set_product, only: [:show, :edit, :update, :destroy, :vote]

    
  def amazon_url
    
    url = params[:amazone_product_page_url]
    asin = url.scan(/http:\/\/(?:www\.|)amazon\.in\/(?:gp\/product|[^\/]+\/dp|dp)\/([^\/]+)/)
    @asin = asin[0]
    request = Vacuum.new
    request = Vacuum.new('IN')

    request.configure(
        aws_access_key_id: 'AKIAIWKESBQCDOOHGX5A',
        aws_secret_access_key: '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',
        associate_tag: 'hipstart-21'
    )

    params = {
      'ItemId' => @asin.first,
      'ResponseGroup' => "Medium,Images"
    }


    raw_product = request.item_lookup(query: params)
    @hashed_product = raw_product.to_h
    
    
    @product_from_amazon = Product.new
     
    @product_from_amazon.name = @hashed_product["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"]
    @product_from_amazon.brand = @hashed_product["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Brand"]
    @product_from_amazon.asin = @hashed_product["ItemLookupResponse"]["Items"]["Item"]["ASIN"]
    @product_from_amazon.author = ""
    @product_from_amazon.small_image_url = @hashed_product["ItemLookupResponse"]["Items"]["Item"]["SmallImage"]["URL"]
    @product_from_amazon.med_image_url = @hashed_product["ItemLookupResponse"]["Items"]["Item"]["MediumImage"]["URL"]
    @product_from_amazon.big_image_url = @hashed_product["ItemLookupResponse"]["Items"]["Item"]["LargeImage"]["URL"]
    @product_from_amazon.product_page_url = @hashed_product["ItemLookupResponse"]["Items"]["Item"]["DetailPageURL"]
    @product_from_amazon.price = search_hash(@hashed_product, "FormattedPrice")
      
    
    
    c = Category.new
    c.name = @hashed_product["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["ProductGroup"]
    
    @product_from_amazon.categories << c
    
    @product_from_amazon.save
    
    redirect_to @product_from_amazon
    
  end
  
  
    def search_hash(hash, search)
      return hash[search] if hash.fetch(search, false)
    
      hash.keys.each do |k|
        answer = search_hash(hash[k], search) if hash[k].is_a? Hash
        return answer if answer
      end
    
      false
    end


  
  # GET /products
  # GET /products.json
  
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end
  
  
  
  
  

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.user = current_user

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  #->Prelang (voting/acts_as_votable)
  def vote

    direction = params[:direction]

    # Make sure we've specified a direction
    raise "No direction parameter specified to #vote action." unless direction

    # Make sure the direction is valid
    unless ["like", "bad"].member? direction
      raise "Direction '#{direction}' is not a valid direction for vote method."
    end

    @product.vote_by voter: current_user, vote: direction

    redirect_to action: :index
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:price, :name, :brand, :user_id, :is_published, :collection_id, :asin, :author)
    end
end
