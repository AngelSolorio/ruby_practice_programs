class Image < ActiveRecord::Base
  belongs_to :product

  validates :product_id, presence: true  
  
  accepts_nested_attributes_for :product, :reject_if => :all_blank

  has_attached_file :image, styles: { medium: '360x>', thumb: '190x>' }

  validates_attachment :image, size: { less_than_or_equal_to: 1.megabytes }, content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'] }
end
