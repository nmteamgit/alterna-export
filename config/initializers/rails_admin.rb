RailsAdmin.config do |config|
  config.main_app_name = 'API Dashboard'
  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  # == Cancan ==
  config.authorize_with :cancan

  config.default_items_per_page = 25

  config.included_models = %w(Admin DashboardLog WvToMailchimpOperation MailchimpToWvOperation MailchimpNewAccount)

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    show
    new { only %w(Admin) }
    edit { only %w(Admin) }
    delete { only %w(Admin) }
    export { only %w(DashboardLog WvToMailchimpOperation MailchimpToWvOperation)}
  end

  config.navigation_static_links = {
    'Dashboard - Overview' => '/admin/dashboard/overview'
  }
end
