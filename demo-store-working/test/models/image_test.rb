require "minitest_helper"

describe Image do
  it "must be valid with correct attributes" do
    admin = Admin.create email: 'admin@store.com', password: '123pass', password_confirmation: '123pass'
    product = Product.create name: 'TV', admin_id: admin.id, description: 'Samsung Smart TV', price: 120000.00, inventory: 2, active: true
    image = Image.create product_id: product.id
    
    image.valid?.must_equal true
  end
  
  it "must be invalid without attributes" do
    image = Image.new
    
    image.valid?.must_equal false
    image.errors[:product_id].wont_be_empty
  end
end
