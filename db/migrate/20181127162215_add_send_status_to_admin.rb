class AddSendStatusToAdmin < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :send_status, :boolean, default: false
    add_index :admins, :send_status
  end
end
