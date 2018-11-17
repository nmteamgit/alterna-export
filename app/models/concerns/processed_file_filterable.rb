module ProcessedFileFilterable
  extend ActiveSupport::Concern

  included do
    scope :wv_to_mv, -> { where(:file_type => 'wv_to_mv') }
    scope :mv_to_wv, -> { where(:file_type => 'mv_to_wv') }
    scope :success, -> { where(:status => 'success') }
    scope :failed, -> { where(:status => 'fail') }
  end

end
