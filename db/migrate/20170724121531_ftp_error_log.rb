class FtpErrorLog < ActiveRecord::Migration[5.0]
  def change
    create_table :ftp_error_logs do |t|
      t.text :error_message
      t.string :list_type
      t.string :action_name

      t.timestamps
    end
  end
end
