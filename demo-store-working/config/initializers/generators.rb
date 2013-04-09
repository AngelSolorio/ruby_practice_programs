Rails.application.config.generators do |g|
  g.test_framework :mini_test, :spec => true, :fixture => true
  g.helper false
  g.assets false
  g.view_specs false
end
