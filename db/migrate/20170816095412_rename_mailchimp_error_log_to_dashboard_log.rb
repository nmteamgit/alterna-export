class RenameMailchimpErrorLogToDashboardLog < ActiveRecord::Migration[5.0]
  def change
    rename_table :mailchimp_error_logs, :dashboard_logs
    add_column :dashboard_logs, :email, :string
    add_column :dashboard_logs, :opcode, :string
    add_column :dashboard_logs, :status, :string

    add_column :dashboard_logs, :error_message, :text
    drop_table :ftp_error_logs do |t|
      t.text :error_message
      t.string :list_type
      t.string :action_name
      t.timestamps
    end
  end
end
