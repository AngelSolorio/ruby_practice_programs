class Admin < ActiveRecord::Base
  has_secure_password validations: true
  has_one :profile
  has_many :products

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, length: { minimum: 6 }, if: -> r { r.password.present? }
  validates :password_confirmation, presence: true, if: -> r { r.password.present? }

  class << self
    def authenticate(email, password)
      admin = Admin.find_by_email(email).try(:authenticate, password)
    end
  end
end
