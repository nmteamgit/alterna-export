class CsvGenerator
  require 'csv'

  def generate_processed_file(filename, read_count, success_count, validation_errors)
    amw_write_file_path = "#{Rails.application.secrets.app_csv_import_path}processed_#{filename}"
    CSV.open(amw_write_file_path, 'wb') do |csv|
      csv << ["Processed at: #{Time.zone.now}", "Read: #{read_count}", "Success: #{success_count}", "Failure: #{validation_errors.count}"]

      if validation_errors.present?
        validation_errors.each do |failure_row|
          csv << (failure_row[0] << failure_row[1])
        end
      end
    end
    return amw_write_file_path
  end

  def generate_mailchimp_trigger_file(list_type)
    timestamp = Time.zone.now.strftime('%Y%m%d_%H%M%S')
    filename = "mw_to_wv_#{timestamp}.csv"
    filepath = Rails.application.secrets.app_csv_export_path+filename
    CSV.open(filepath, 'wb', { row_sep: "\r\n" }) do |csv|
      csv << AlternaExport::Application.config.CSV_HEADER
      MailchimpToWvOperation.to_be_processed(list_type).each do |record|
        data = record.data
        fired_at = DateTime.parse(data['fired_at']).utc.strftime('%Y%m%d%H%M%S')
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
    return filepath
  end

end
