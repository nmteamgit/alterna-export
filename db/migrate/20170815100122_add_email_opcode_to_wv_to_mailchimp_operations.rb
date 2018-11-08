class AddEmailOpcodeToWvToMailchimpOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :wv_to_mailchimp_operations, :email, :string
    add_column :wv_to_mailchimp_operations, :opcode, :string

    remove_column :wv_to_mailchimp_operations, :action_name, :string
    add_column :wv_to_mailchimp_operations, :created_at, :datetime, null: false
    add_column :wv_to_mailchimp_operations, :updated_at, :datetime, null: false
  end
end
