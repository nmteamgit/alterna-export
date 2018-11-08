class CreateMailchimpErrorLog < ActiveRecord::Migration[5.0]
  def change
    create_table :mailchimp_error_logs do |t|
      t.text :request_params
      t.text :response_params
      t.string :status_code
      t.string :mailchimp_list_type
      t.string :request_type
      t.string :filename

      t.timestamps
    end
  end
end
