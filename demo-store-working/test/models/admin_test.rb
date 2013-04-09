require "minitest_helper"

describe Admin do
  let(:admin) { Admin.new }

  describe 'Validations' do
    it "must be valid" do
      admin.email = 'user@store.com'
      admin.password = 'password'
      admin.password_confirmation = 'password'

      admin.valid?.must_equal true
    end

    it "must be invalid without attributes" do
      admin.valid?.must_equal false

      admin.errors.size.must_equal 3
      admin.errors[:email].wont_be_empty
      admin.errors[:password].wont_be_empty
    end

    it "must invalid without unique email" do
      Admin.create email: 'user@store.com', password: '123pass', password_confirmation: '123pass'

      admin.email = 'user@store.com'
      admin.password = 'password'
      admin.password_confirmation = 'password'

      admin.valid?.must_equal false
      admin.errors[:email].wont_be_empty
    end

    describe 'Password' do
      it 'must be invalid when password confirmation does not match' do
        admin.email = 'user@store.com'
        admin.password = 'password'

        admin.valid?.must_equal false
        admin.errors[:password_confirmation].wont_be_empty
      end

      it "must be invalid when password is less than 6 chars" do
        admin.email = 'user@store.com'
        admin.password = 'pass'

        admin.valid?.must_equal false
        admin.errors[:password].wont_be_empty
      end
    end

    describe 'Email' do
      it 'must be invalid with invalid email address' do
        admin.email = 'some text'
        admin.password = 'password'
        admin.password_confirmation = 'password'

        admin.valid?.must_equal false
        admin.errors[:email].wont_be_empty
      end
    end
  end

  describe 'Password encryption' do
    it "must generate a salt and hash on save" do
      user = Admin.create email: 'user@store.com', password: '123pass', password_confirmation: '123pass'

      user.password_digest.wont_be_nil
    end

    it "must authenticate user with valid credentials" do
      user = Admin.create email: 'user@store.com', password: '123pass', password_confirmation: '123pass'

      Admin.authenticate('user@store.com', '123pass').must_equal user
    end
  end
end
