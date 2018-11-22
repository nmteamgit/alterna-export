class AddIndicesToNecessaryTables < ActiveRecord::Migration[5.0]
  def change
    add_index :wv_to_mailchimp_operations, :status
    add_index :wv_to_mailchimp_operations, :mailchimp_list_type
    add_index :mailchimp_to_wv_operations, :status
    add_index :mailchimp_to_wv_operations, [:mailchimp_list_type, :action_name, :wv_row_id], name: 'mc_list_and_wv_row'
  end
end
