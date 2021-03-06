module AdminConfig
  extend ActiveSupport::Concern

  included do
    rails_admin do
      label "Users"
      create do
        field :name
        field :email
        field :password do
          required true
        end
        field :role
      end
      edit do
        field :name do
          required true
        end
        field :email do
          required true
        end
        field :password do
          read_only true
          required true
        end
        field :role do
          required true
        end
      end
      list do
        field :role do
          filterable false
        end
        field :created_at do
          label 'Date Registered'
          filterable false
        end
        field :name do
          label 'Username'
          filterable false
        end
        field :email do
          label 'Email Address'
          filterable false
        end
        field :send_status do
          css_class "enable_send_pointer text-center"
          label 'Receive Notification Email'
          filterable false
        end
      end
    end
  end
end
