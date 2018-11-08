class AddColumnEmailConsentToWvToMailchimpOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :wv_to_mailchimp_operations, :email_consent, :string
    add_column :mailchimp_to_wv_operations, :email_consent, :string

    add_index :wv_to_mailchimp_operations, [:email_consent, :opcode]
    add_index :mailchimp_to_wv_operations, [:email_consent, :opcode]
    add_index :wv_to_mailchimp_operations, :updated_at
    add_index :mailchimp_to_wv_operations, :updated_at
  end
end
