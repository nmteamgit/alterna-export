module ProcessedFileConfig
  extend ActiveSupport::Concern

  included do
    rails_admin do
      label 'Transmitted Files'
      list do
        sort_by :created_at
        scopes [nil, :yesterday, :last_7_days, :last_30_days, :last_90_days]
        field :created_at do
          label 'Date'
          filterable false
        end
        field :file_name do
          formatted_value do
            path = "/csv_imports/processed_" + bindings[:object].file_name if bindings[:object].file_path.present?
            if bindings[:object].status == "Fail" && path
              bindings[:view].link_to(bindings[:object].file_name, path)
            else
              bindings[:object].file_name
            end
          end
          filterable false
        end
        field :status do
          filterable false
        end
        field :file_type do
          filterable false
        end
        field :processed_rows do
          label 'Success'
          filterable false
        end
        field :unprocessed_rows do
          label 'Fails'
          filterable false
        end
        field :total_rows do
          label 'Total'
          filterable false
        end
      end
    end
  end
end
