module MailchimpToWvOperationConfig
  extend ActiveSupport::Concern

  included do
    rails_admin do
      label 'Mailchimp Updates'
      list do
        sort_by :updated_at
        scopes [nil, :today, :yesterday, :last_7_days, :last_30_days, :last_90_days]
        filters [:updated_at]
        field :updated_at do
          label 'date'
        end
        field :details do
          filterable false
        end
        field :email do
          label 'Email Address'
          filterable false
        end
        field :mailchimp_list_type do
          label 'Mailchimp List Name'
          filterable false
        end
      end
      show do
        field :details
        field :email
        field :mailchimp_list_type do
          label 'Mailchimp List Name'
        end
        field :data
        field :created_at
        field :updated_at
      end
      export do
        field :details do
          pretty_value do
            bindings[:object].details
          end
        end
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
