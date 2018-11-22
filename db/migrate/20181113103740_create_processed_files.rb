class CreateProcessedFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :processed_files do |t|
      t.string :file_name
      t.string :file_path
      t.string :status
      t.string :file_type
      t.integer :unprocessed_rows
      t.integer :processed_rows
      t.integer :total_rows

      t.timestamps
    end
    add_index :processed_files, :status
    add_index :processed_files, :file_type
  end
end
