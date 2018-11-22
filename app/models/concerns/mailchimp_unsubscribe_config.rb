module MailchimpUnsubscribeConfig
  extend ActiveSupport::Concern
  included do
    rails_admin do
      label 'Mailchimp Unsubscribes'
      list do
        sort_reverse :updated_at
        scopes [nil, :today, :yesterday, :last_7_days, :last_30_days, :last_90_days]
        filters [:updated_at]
        field :updated_at do
          label 'Date'
        end
        field :email do
          label 'Email Address'
          filterable false
        end
        field :mailchimp_list_type do
          label 'Mailchimp List Name'
          filterable false
        end
        field :status do
          pretty_value do
            bindings[:object].status.upcase
          end
          filterable false
        end
      end
      show do
        field :email
        field :mailchimp_list_type do
          label 'Mailchimp List Name'
        end
        field :status do
          pretty_value do
            bindings[:object].status.upcase
          end
        end
        field :data do
          label 'Request Details'
          pretty_value do
            JSON.pretty_generate(bindings[:object].data)
          end
        end
        field :details do
          label 'Response Details'
          pretty_value do
            JSON.pretty_generate(bindings[:object].details)
          end
        end
        field :created_at
        field :updated_at
      end
      export do
        field :email
        field :mailchimp_list_type do
          label 'Mailchimp List Name'
        end
        field :status do
          pretty_value do
            bindings[:object].status.upcase
          end
        end
        field :data do
          label 'Request Details'
        end
        field :details do
          label 'Response Details'
        end
        field :created_at
      end
    end
  end
end
