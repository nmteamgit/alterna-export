class CreateMailchimpNewAccountsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :mailchimp_new_accounts do |t|
      t.string :email
      t.text :data
      t.string :mailchimp_list_type

      t.timestamps
    end
  end
end
