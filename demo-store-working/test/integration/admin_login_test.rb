require 'minitest_helper'

feature 'admin login' do
  background do
    logout_admin
    visit '/backend/sign_in'
  end

  scenario 'Admin with valid credentials can login' do
    Admin.create email: 'admin@store.com', password: 'password', password_confirmation: 'password'

    within('#new_admin') do
      fill_in 'admin_email', with: 'admin@store.com'
      fill_in 'admin_password', with: 'password'
    end
    click_button 'login'

    assert page.has_text?('Bienvenido admin@store.com')
  end

  scenario 'Admin with invalid credentials should see an error' do
    within('#new_admin') do
      fill_in 'admin_email', with: 'admin@store.com'
      fill_in 'admin_password', with: 'passwords'
    end
    click_button 'login'

    assert page.has_text?('Por favor verifique sus credenciales')
  end

  scenario 'Already logged admin should be able to logout' do
    login_admin

    click_link 'Cerrar sesion'
    assert page.has_text?('Iniciar sesion')
  end

  scenario 'An admin must be logged to navigate backend' do
    visit backend_root_path

    assert page.has_text?('Iniciar sesion')
  end
end

def logout_admin
  visit '/backend'
  all('.logout').each{|l| l.click}
end

def login_admin
  counter = Admin.count + 1
  email = "admin#{counter}@store.com"
  Admin.create! email: email, password: 'password', password_confirmation: 'password'

  within('#new_admin') do
    fill_in 'admin_email', with: email
    fill_in 'admin_password', with: 'password'
  end
  click_button 'login'
end
