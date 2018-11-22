class AddFilenameToWvToMailchimpOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :wv_to_mailchimp_operations, :filename, :string
  end
end
