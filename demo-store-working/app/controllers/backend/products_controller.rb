class Backend::ProductsController < ApplicationController
  before_action :authenticate!
  before_action :verify_admin_and_product, only: [:show, :edit, :update]

  def index
    @products = Product.my_products(current_admin)
  end

  def new
    @product = Product.new
    5.times { @product.images.build }
  end

  def show
    @product = Product.my_product(params[:id], current_admin).first
    redirect_to backend_products_path
  end

  def create
    @product = Product.new(permit_params_product)
    @product.inventory = -1 if params[:product][:inventory_check] == "1"
    @product.admin = current_admin
    upload_files params[:product][:images_attributes]

    if @product.save
      return redirect_to backend_products_path, notice: t('.product_created')
    end

    flash[:notice] = t('.product_no_created')
    5.times { @product.images.build }
    render :new
  end

  def edit
    @product = Product.my_product(params[:id], current_admin).first
    
    if @product.nil?
      return redirect_to backend_products_path, alert: t('.product_no_found')
    end
    
    (5 - @product.images.count).times { @product.images.build }
    
    if @product.inventory == -1
      @product.inventory = ""
      @product.inventory_check = true
    end
  end

  def update
    product_params = permit_params_product
    product_params[:inventory] = -1 if params[:product][:inventory_check] == '1'

    upload_files params[:product][:images_attributes]

    params[:product][:images_attributes].each do |key, value|
      if value[:_destroy] == '1'
        @product.images.find(value[:id]).delete
      end
    end

    if @product.update_attributes(product_params)
      return redirect_to backend_product_path(@product), alert: t('.product_updated')
    end

    flash[:alert] = t('.product_no_updated')
    (5 - @product.images.size).times { @product.images.build }
    return render action: 'edit'
  end

  protected
  def verify_admin_and_product
    @product = Product.my_product(params[:id], current_admin).first
    if @product.nil?
      return redirect_to backend_products_path, alert: t('.product_no_found')
    end
  end

  def permit_params_product
    params.require(:product).permit(:name, :description, :price, :inventory, :active, :tags)
  end

  def upload_files files
    unless files.blank?
        files.each do |key, value|
          @product.images.build value if value[:_destroy].nil?
        end
    end
  end
end
