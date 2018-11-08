class AddEmailOpcodeToMailchimpToWvOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :mailchimp_to_wv_operations, :email, :string
    add_column :mailchimp_to_wv_operations, :opcode, :string
    add_column :mailchimp_to_wv_operations, :created_at, :datetime, null: false
    add_column :mailchimp_to_wv_operations, :updated_at, :datetime, null: false
  end
end
