module DashboardLogConfig
  extend ActiveSupport::Concern

  included do
    rails_admin do
      label 'Activity'
      list do
        sort_by :updated_at
        scopes [nil, :today, :yesterday, :last_7_days, :last_30_days, :last_90_days]
        filters [:updated_at]
        field :status do
          filterable false
        end
        field :updated_at do
          label 'Date'
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
        field :status
        field :details
        field :status_code
        field :email
        field :opcode
        field :mailchimp_list_type do
          label 'Mailchimp List Name'
        end
        field :request_type
        field :error_message
        field :filename
        field :request_params do
          pretty_value do
            JSON.pretty_generate(bindings[:object].request_params)
          end
        end
        field :response_params do
          pretty_value do
            JSON.pretty_generate(bindings[:object].response_params)
          end
        end
        field :created_at
        field :updated_at
      end
      export do
        field :status
        field :details do
          pretty_value do
            bindings[:object].details
          end
        end
        field :status_code
        field :email
        field :opcode
        field :mailchimp_list_type do
          label 'Mailchimp List Name'
        end
        field :request_type
        field :error_message
        field :filename
        field :request_params
        field :response_params
        field :created_at
        field :updated_at
      end
    end
  end
end
