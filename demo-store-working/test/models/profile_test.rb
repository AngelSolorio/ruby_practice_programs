require "minitest_helper"

describe Profile do
  let(:profile) { Profile.new }

  it "must be valid" do
    admin = Admin.create email: 'a@store.com', password: 'password', password_confirmation: 'password'

    profile.name = 'Super admin'
    profile.admin = admin
    profile.valid?.must_equal true
  end

  it "must be invalid without attributes" do
    profile.valid?.must_equal false

    profile.errors.size.must_equal 2
    profile.errors[:name].wont_be_nil
    profile.errors[:admin_id].wont_be_nil
  end

end
