# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AlternaExport::Application.config.ADMIN_ROLES.each do |name|
  role = Role.find_or_create_by(name: name)
  if role.name == 'superadmin' and Admin.find_by_email(Rails.application.secrets.superadminemail).blank?
    Admin.create(name: 'superadmin', email: Rails.application.secrets.superadminemail, password: Rails.application.secrets.superadminpwd, password_confirmation: Rails.application.secrets.superadminpwd, role_id: role.id)
  end
end
