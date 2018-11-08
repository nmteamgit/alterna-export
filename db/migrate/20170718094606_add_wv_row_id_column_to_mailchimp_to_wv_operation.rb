class AddWvRowIdColumnToMailchimpToWvOperation < ActiveRecord::Migration[5.0]
  def change
    add_column :mailchimp_to_wv_operations, :wv_row_id, :string
  end
end
