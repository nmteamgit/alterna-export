class MailchimpUnsubscribe < ActiveRecord::Migration[5.0]
  def change
    create_table :mailchimp_unsubscribes do |t|
      t.string :email
      t.string :mailchimp_list_type
      t.text :data
      t.text :details
      t.string :status

      t.timestamps
    end
  end
end
