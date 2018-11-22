class AddListIdToMailchimpOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :wv_to_mailchimp_operations, :mailchimp_list_type, :string
    add_column :mailchimp_to_wv_operations, :mailchimp_list_type, :string
  end
end
