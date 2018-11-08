class CreateWvToMailchimpOperations < ActiveRecord::Migration[5.0]
  def change
    create_table :wv_to_mailchimp_operations do |t|
      t.text :data
      t.string :action_name
      t.string :status
    end
  end
end
