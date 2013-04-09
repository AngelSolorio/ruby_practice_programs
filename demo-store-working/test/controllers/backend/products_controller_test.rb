require "minitest_helper"

describe Backend::ProductsController do
  before do
    stub_current_admin
  end

  describe 'show' do
    it "when haven't products" do
      stub_current_admin 200
      
      get :show, :id => 1
      
      assert_response :redirect
      assert_redirected_to backend_product_path(1)
      #assigns[:product].wont_be_nil   
    end
    
    it "when have products" do
      stub_current_admin 100
      
      get :index
      
      assert_redirected_to backend_products_path 
      assert_template :index
      assigns[:products].wont_be_nil
    end
  end

  describe 'new' do
    let(:params) {
      {
        product: { name: 'Toshiba TV', description: 'Toshiba 3D Smart TV 50"', price: 1200, inventory: 2, active: true, tags: 'tv' }
      }
    }
    
    it "should method new display a form to register a new product" do
      stub_current_admin 100
      
      get :new, params
      
      assert_redirected_to new_backend_product_path
      assert_template :new
      assigns[:product].wont_be_nil
    end
  end

  describe 'edit' do
    it "should display a form to edit the product attributes if admin own the product" do
      stub_current_admin 100
      
      get :edit, id: 1
      
      assert_response :success
      assert_template :edit
      assigns[:product].wont_be_nil
    end
   end

  describe 'update' do
    let(:params) {
      {
        product: { name: 'Samsung TV', description: 'Samsung Smart TV 49"', price: 8500, inventory: 4, active: true, tags: 'tv, samsung' }
      }
    }
  
#     it 'should redirect to create product when the admin is not logged in' do
#       put :update, params
#   
#       assert_redirected_to new_backend_product_path
#       flash[:notice].wont_be_nil
#     end
    
    it "should update a product and redirect to product show" do
      put :update, { id: 1 }, params
      #put :update, :id => 1, params
      
      assert_redirected_to backend_product_path(params[:id])
      flash[:notice].wont_be_nil
    end
    
    it "should display edit form if product is invalid" do
      params[:product][:name] = ''
      
      put :update, { id: 1 }, params
      
      assert_response :success
      assert_template :edit
      flash[:alert].wont_be_nil
    end
  end

#   describe 'post' do
#     let(:params) {
#       {
#         product: { name: 'Macbook Pro', description: 'Macbook Pro Retina Display 15"', price: 2199, inventory: 2, active: true, tags: 'apple, laptop, macbook pro' }
#       }
#     }
#     
#     it "should create a product and redirect to product show" do
#       stub_current_admin 100
#       
#       post :create, params
#       
#       assert_redirected_to backend_product_path(params[:product][:id])
#       flash[:notice].wont_be_nil
#     end
#     
#     it 'should fail to create product and redisplay form when product is invalid' do
#       stub_current_admin 200
#       
#       params[:product][:name] = ''
#       post :create, params
#       
#       assert_response :success
#       assert_template :new
#       flash[:alert].wont_be_nil
#       assigns[:product].errors.size.must_equal 1
#     end
#   end
end

def stub_current_admin(id = 100)
  Backend::ProfileController.class_exec(id) do |id|
    body = -> { @admin ||= Admin.find id }
    define_method :current_admin, body
  end
end