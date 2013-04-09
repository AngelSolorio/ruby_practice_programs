require "minitest_helper"

describe Product do

  it "must be valid with correct attributes" do
    admin = Admin.create email: 'admin@store.com', password: '123pass', password_confirmation: '123pass'
    product = Product.create name: 'TV', admin_id: admin.id, description: 'Samsung Smart TV', price: 120000.00, inventory: 2, active: true
    
    product.valid?.must_equal true
  end

  it "must be invalid without attributes" do
    empty_product = Product.new
    empty_product.valid?.must_equal false

    empty_product.errors.size.must_equal 7
    empty_product.errors[:admin_id].wont_be_nil
    empty_product.errors[:name].wont_be_nil
    empty_product.errors[:description].wont_be_nil
    empty_product.errors[:price].wont_be_nil
    empty_product.errors[:inventory].wont_be_nil
    empty_product.errors[:active].wont_be_nil
  end
  
  it "No two products with the same name for the same user could coexists" do
    admin = Admin.create email: 'admin@store.com', password: '123pass', password_confirmation: '123pass'
    product1 = Product.create name: 'TV', admin_id: admin.id, description: 'Samsung Smart TV', price: 120000.00, inventory: 2, active: true
    product2 = Product.create name: 'tv', admin_id: admin.id, description: 'New Samsung Smart TV', price: 12500.00, inventory: 1, active: true
    
    product1.valid?.must_equal true
    product2.valid?.must_equal false
    product2.errors[:name].wont_be_empty
  end
  
  it "price must be greater than cero " do
    admin = Admin.create email: 'admin@store.com', password: '123pass', password_confirmation: '123pass'
    product = Product.new name: 'TV', admin_id: admin.id, description: 'Samsung Smart TV', price: 0.00, inventory: 2, active: true
    
    product.valid?.must_equal false
    product.errors[:price].wont_be_empty
  end
  
  it "inventory must be an integer and greater than -1" do
    admin = Admin.create email: 'admin@store.com', password: '123pass', password_confirmation: '123pass'
    product = Product.new name: 'TV', admin_id: admin.id, description: 'Samsung Smart TV', price: 120000.00, inventory: -2, active: true
    
    product.valid?.must_equal false
    product.errors[:inventory].wont_be_empty
  end

end