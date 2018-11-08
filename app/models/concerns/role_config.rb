module RoleConfig
  extend ActiveSupport::Concern

  included do
    rails_admin do
      create do
        field :name
      end
      edit do
        field :name do
          required true
        end
      end
      list do
        field :id
        field :name
        field :created_at
        field :updated_at
      end
    end
  end
end
