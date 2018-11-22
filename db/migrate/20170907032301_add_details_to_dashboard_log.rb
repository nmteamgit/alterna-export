class AddDetailsToDashboardLog < ActiveRecord::Migration[5.0]
  def change
    add_column :dashboard_logs, :details, :text
  end
end
