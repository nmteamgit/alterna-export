class CsvGenerator
  require 'csv'

  def generate_processed_file(filename, read_count, success_count, validation_errors)
    amw_write_file_path = "#{Rails.application.secrets.app_csv_import_path}processed_#{filename}"
    CSV.open(amw_write_file_path, 'wb') do |csv|
      csv << ["Processed at: #{Time.zone.now}", "Read: #{read_count}", "Success: #{success_count}", "Failure: #{validation_errors.count}"]

      if validation_errors.present?
        validation_errors.each do |failure_row|
          csv << (failure_row[0] << failure_row[1]  << failure_row[2])
        end
      end
    end
    return amw_write_file_path
  end

  def generate_mailchimp_trigger_file(list_type)
    timestamp = DateTime.now.strftime('%Q')
    filename = "mw_to_wv_#{timestamp}.csv"
    filepath = Rails.application.secrets.app_csv_export_path+filename
    row_count = 0
    CSV.open(filepath, 'wb', { row_sep: "\r\n" }) do |csv|
      csv << AlternaExport::Application.config.CSV_HEADER
      MailchimpToWvOperation.to_be_processed(list_type).each do |record|
        row_count += 1
        data = record.data
        fired_at = DateTime.parse(data['fired_at'].present? ? data['fired_at'] : record.created_at.to_s).utc.strftime('%Y%m%d%H%M%S')
        if ['11', '12', '14'].include?(record.op_code)
          merge_params = data['data']['merges']
          csv << [record.opcode,
                  fired_at,
                  merge_params['WV_ROW_ID'],
                  record.email.downcase,
                  '',
                  '',
                  record.email_consent,
                  record.interests,
                  merge_params['LANGUAGE'],
                  '',
                  '',
                  '',
                  '',
                  '',
                  merge_params['BUS_NAME']
                 ]
        elsif record.op_code == '13'
          csv << [record.opcode, fired_at, record.get_wv_row_id_for_upemail,
                  data['data']['old_email'], '', '', '', '', '', '', '', '', '',
                  data['data']['new_email'], '']
        end
        record.update_attributes(status: 'generated')
      end
    end
    ProcessedFile.create(file_name: filename, 
      file_path: filepath, 
      status: "Processed", 
      file_type: "mv_to_wv", 
      processed_rows: row_count,
      unprocessed_rows: 0,
      total_rows: row_count
    )

    return filepath
  end

end
