class Backend::SessionController < ApplicationController
  before_action :already_in_session!, except: :destroy

  def new
    @admin = Admin.new
  end

  def create
    email = params[:admin][:email]
    password = params[:admin][:password]

    @admin = Admin.authenticate(email, password) || Admin.new(email: email).tap{ |admin| admin.valid? }

    unless @admin.new_record?
      session[:admin_id] = @admin.id
      return respond_with @admin, location: backend_root_path
    end

    respond_with @admin, flash_now: true, alert: t('login_errors.message')
  end

  def destroy
    session[:admin_id] = nil

    redirect_to backend_sign_in_path
  end
end
