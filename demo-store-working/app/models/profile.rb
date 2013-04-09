class Profile < ActiveRecord::Base
  belongs_to :admin

  validates :name, :admin_id, presence: true

  accepts_nested_attributes_for :admin, :reject_if => :new_record?, update_only: true

  has_attached_file :avatar, styles: { medium: '200x200>', thumb: '48x48>' }

  validates_attachment :avatar, size: { less_than: 501.kilobytes }, content_type: { content_type: 'image/jpeg' }
end