class Role < ApplicationRecord
  include RoleConfig
  validates :name, presence: true, uniqueness: true

  has_many :admins, dependent: :destroy
end
