class AddUnprocessedWasToProcessedFile < ActiveRecord::Migration[5.0]
  def change
    add_column :processed_files, :unprocessed_was, :integer
  end
end
