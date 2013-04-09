class Product < ActiveRecord::Base
  attr_accessor :inventory_check
  
  belongs_to :admin
  has_many :images

  validates :name, :admin_id, :description, :price, :inventory, presence: true
  validates :name, :uniqueness => { :scope => :admin_id, :message => "Nombre de producto repetido", :case_sensitive => false }
  validates :price, :numericality => { :greater_than => 1, :message => "Precio incorrecto" }
  validates :inventory, :numericality => { :only_integer => true, :greater_than_or_equal_to => -1, :message => "No se permiten cantidades negativas" }

  accepts_nested_attributes_for :images

  scope :my_products, -> (admin) { where(:admin_id => admin.id).order(:id) }
  scope :my_product, -> (product_id, admin) { where(:id => product_id, :admin_id => admin.id) }
  
end