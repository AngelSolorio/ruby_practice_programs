require "minitest_helper"

describe Backend::ProfileController do
  before do
    stub_current_admin
  end

  describe 'show' do
    it "when admin have no profile" do
      stub_current_admin 200

      get :show

      assert_redirected_to new_backend_profile_path
    end

    it "when admin have profile" do

      get :show

      assert_response :success
      assert_template :show
      assigns[:profile].wont_be_nil
    end
  end

  describe 'new' do
    it "should new display a form" do
      stub_current_admin 200

      get :new

      assert_response :success
      assert_template :new
      assigns[:profile].wont_be_nil
    end

    it "should redirect to show if already have profile" do
      get :new

      assert_redirected_to backend_profile_path
      flash[:notice].wont_be_nil
    end
  end

  describe 'edit' do
    it "should edit display a form" do
      get :edit

      assert_response :success
      assert_template :edit
      assigns[:profile].wont_be_nil
    end

    it "should redirect to new when user have no profile" do
      stub_current_admin 200

      get :edit

      assert_redirected_to new_backend_profile_path
      flash[:notice].wont_be_nil
    end
  end

  describe 'post' do
    let(:params) {
      {
        profile: { name: 'Super admin' ,
          admin_attributes: { password: '', password_confirmation: '' }
        }
      }
    }

    it "should create a profile and redirect to profile show" do
      stub_current_admin 200

      post :create, params

      assert_redirected_to backend_profile_path
      flash[:notice].wont_be_nil
    end

    it 'should create a profile, set new password and redirect to profile show' do
      stub_current_admin 200

      params[:profile][:admin_attributes][:password] = 'superpass'
      params[:profile][:admin_attributes][:password_confirmation] = 'superpass'
      post :create, params

      assert_redirected_to backend_profile_path
      flash[:notice].wont_be_nil
    end

    it 'should fail to create profile and redisplay form when profile is invalid' do
      stub_current_admin 200

      params[:profile][:name] = ''
      post :create, params

      assert_response :success
      assert_template :new
      flash[:alert].wont_be_nil
      assigns[:profile].errors.size.must_equal 1
    end

    it 'should fail to create a profile and redisplay form when password is invalid' do
      stub_current_admin 200

      params[:profile][:admin_attributes][:password] = 'pass'
      post :create, params

      assert_response :success
      assert_template :new
      flash[:alert].wont_be_nil
      assigns[:profile].errors.size.must_equal 3
    end
  end

  describe 'update' do
    let(:params) {
      {
        profile: { name: 'Super admin' ,
          admin_attributes: { id: 100, password: '', password_confirmation: '' }
        }
      }
    }

    it 'should redirect to create profile when no profile available' do
      stub_current_admin 200

      put :update, params

      assert_redirected_to new_backend_profile_path
      flash[:notice].wont_be_nil
    end

    it "should update a profile and redirect to profile show" do

      put :update, params

      assert_redirected_to backend_profile_path
      flash[:notice].wont_be_nil
    end

    it "should display edit form if profile is invalid" do
      params[:profile][:name] = ''

      put :update, params

      assert_response :success
      assert_template :edit
      flash[:alert].wont_be_nil
    end

    it "should update profile and password and redirect to profile show" do
      params[:profile][:admin_attributes][:password] = 'superpass'
      params[:profile][:admin_attributes][:password_confirmation] = 'superpass'
      put :update, params

      assert_redirected_to backend_profile_path
      flash[:notice].wont_be_nil
    end

    it "should display edit form if password is invalid" do
      params[:profile][:admin_attributes][:password] = 'super'

      put :update, params

      assert_response :success
      assert_template :edit
      flash[:alert].wont_be_nil
    end
  end
end

def stub_current_admin(id = 100)
  Backend::ProfileController.class_exec(id) do |id|
    body = -> { @admin ||= Admin.find id }
    define_method :current_admin, body
  end
end
