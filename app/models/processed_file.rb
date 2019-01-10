class ProcessedFile < ActiveRecord::Base
  include Filterable
  include ProcessedFileFilterable
  include ProcessedFileConfig

end
