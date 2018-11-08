module MailchimpNewAccountConfig
  extend ActiveSupport::Concern

  included do
    rails_admin do
      label 'New Subscribes'
      list do
        sort_by :updated_at
        field :updated_at do
          label 'Date'
          filterable false
        end
        field :email do
          filterable false
        end
        field :mailchimp_list_type do
          filterable false
        end
      end
      show do
        field :email
        field :mailchimp_list_type do
          label 'Mailchimp List Name'
        end
        field :data
        field :created_at
        field :updated_at
      end
    end
  end
end
