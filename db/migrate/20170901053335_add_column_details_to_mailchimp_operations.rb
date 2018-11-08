class AddColumnDetailsToMailchimpOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :mailchimp_to_wv_operations, :details, :text
    add_column :wv_to_mailchimp_operations, :details, :text
  end
end
