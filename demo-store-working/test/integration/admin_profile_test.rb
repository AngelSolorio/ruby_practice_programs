require 'minitest_helper'

feature 'admin profile' do
  background do
    logout_admin
    login_admin
  end

  scenario 'Admin navigates to profile and update name (without profile)' do
    visit '/backend/profile'

    assert page.has_selector?('.notice', text: 'Actualice su perfil')

    within('.new_profile') do
      fill_in 'profile_name', with: 'Super admin'
    end
    click_button 'update'

    assert page.has_text?('Su Perfil fue actualizado(a)')
  end

  scenario 'Admin navigates to profile and change password (with profile)' do
    create_profile

    visit '/backend/profile'

    click_link 'update'
    assert page.has_text?('Actualice su perfil')

    within('.edit_profile') do
      fill_in 'profile_admin_attributes_password', with: 'password'
      fill_in 'profile_admin_attributes_password_confirmation', with: 'password'
    end
    click_button 'update'

    assert page.has_text?('Su Perfil fue actualizado(a)')
  end

  scenario 'Admin navigates to profile and get error when change password (with profile)' do
    create_profile

    visit '/backend/profile'

    click_link 'update'
    assert page.has_text?('Actualice su perfil')

    within('.edit_profile') do
      fill_in 'profile_admin_attributes_password', with: 'pass'
      fill_in 'profile_admin_attributes_password_confirmation', with: 'password'
    end
    click_button 'update'

    assert page.has_text?('Su perfil no pudo ser actualizado')
  end

  scenario 'Admin navigates to new profile but gets redirected to show when already have profile' do
    create_profile

    visit '/backend/profile/new'

    assert page.has_text?('Usted ya cuenta con perfil')
  end

  scenario 'Show profile' do
    profile = create_profile

    visit '/backend/profile'

    assert page.has_selector?('.input', text: profile.name)
    assert page.has_selector?('.input', text: profile.admin.email)
  end
end

def create_profile
  Admin.last.create_profile name: 'Admin user'
end
