class Backend::ProfileController < ApplicationController
  def show
    @profile = current_admin.profile

    options = @profile ? {} : { location: new_backend_profile_path, notice: t('.update_profile') }

    respond_with @profile, options
  end

  def new
    @profile = current_admin.profile || current_admin.build_profile

    options = @profile.new_record? ? {} : { location: backend_profile_path, notice: t('.already_have_profile') }

    respond_with @profile, options
  end

  def edit
    @profile = current_admin.profile

    options = @profile ? {} : { location: new_backend_profile_path, notice: t('.create_a_profile') }

    respond_with @profile, options
  end

  def create
    @profile = current_admin.build_profile profile_params.except(:admin_attributes)
    set_password_attributes!

    saved = @profile.save
    respond_with @profile, flash_now: !saved
  end

  def update
    @profile = Profile.find_by_id current_admin.profile
    return redirect_to new_backend_profile_path, notice: t('.create_a_profile') unless @profile

    set_password_attributes!
    update_params = @profile.admin.password.present? ? profile_params : profile_params.except(:admin_attributes)
    @profile.update_attributes update_params

    respond_with @profile
  end

protected
  def set_password_attributes!
    if profile_params[:admin_attributes][:password].present?
      @profile.admin.password = profile_params[:admin_attributes][:password]
      @profile.admin.password_confirmation = profile_params[:admin_attributes][:password_confirmation]
    end
  end

  def profile_params
    params.require(:profile).permit(:name, :avatar, admin_attributes: [:password, :password_confirmation, :id])
  end
end
