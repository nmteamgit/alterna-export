class Admin < ApplicationRecord
  include AdminConfig

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :role

  validates :name, :email, :role_id, presence: true
  validates :email, uniqueness: true

  AlternaExport::Application.config.ADMIN_ROLES.each do |attribute|
    define_method("#{attribute}_role?") do
      role.name == attribute
    end
  end

end
