class CreateMailchimpToWvOperations < ActiveRecord::Migration[5.0]
  def change
    create_table :mailchimp_to_wv_operations do |t|
      t.text :data
      t.string :status
      t.string :action_name
    end
  end
end
