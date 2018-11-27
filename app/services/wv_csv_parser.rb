class WvCsvParser
  require 'csv'
  include CsvValidation
  include SharedMethods

  def initialize(params)
    @validation_errors = []
    @row = {}
    @read_count = 0
    @success_count = 0
    @list_type = params[:listname]
    @file_path = params[:filepath]
  end

  def perform
    CSV.foreach(@file_path, {encoding:'iso-8859-1:utf-8', headers: true}) do |sheet_row|
      AlternaExport::Application.config.CSV_HEADER.each_with_index do |key,index|
        @row[key] = sheet_row[index]
        if key == "new_email" && @row[key].present?
          @row["email"] = @row[key]
        end 

        if key == "op_code"
          @row[key] = sprintf('%02d', sheet_row[index].to_i)
        end
      end
      @read_count += 1
      row_with_values = @row.select {|k,v| v.present?}
      process_row(row_with_values)
      # delete the read file
      
    end
    ProcessedFile.create(file_name: File.basename(@file_path), 
      file_path: @file_path, 
      status: @validation_errors.blank? ? "Success" : "Fail", 
      file_type: "wv_to_mv", 
      processed_rows: @success_count,
      unprocessed_rows: @read_count - @success_count,
      total_rows: @read_count
    )
    File.delete(@file_path) if File.exist?(@file_path) && @validation_errors.empty?

    ProcessedFileMailer.send_processed_file_status(File.basename(@file_path), @validation_errors.empty? ? "Success" : "Failed", "wv_to_mv").deliver_now

    return { read_count: @read_count,
             success_count: @success_count,
             validation_errors: @validation_errors
           }
  end

  private

  def isEmail(str)
    return str.match(/[a-zA-Z0-9._%]@(?:[a-zA-Z0-9]\.)[a-zA-Z]{2,4}/)
  end

  def add_to_queue
    @row['email'] = @row['email'].downcase
    WvToMailchimpOperation.create(data: @row,
                                  mailchimp_list_type: @list_type,
                                  filename: File.basename(@file_path),
                                  email: @row['email'],
                                  opcode: @row['op_code'],
                                  email_consent: @row['email_consent'],
                                  details: get_opcode_details(@row['op_code'],@row['email_consent'])
                                  )
  end

  def row_operation(mandatory_values, row_with_values)
    if (mandatory_values - row_with_values.keys).empty?
      @success_count += 1
      add_to_queue
    else
      @validation_errors << [@row.values,
                             I18n.t('wv_to_mv.csv.validation_message',
                               values: mandatory_values.join(' |')), "Missing values #{mandatory_values - row_with_values.keys}"
                            ]
    end
  end

  def process_row(row_with_values)
    case @row['op_code']
    when '01'
      row_operation(new_subscriber_required_fields,
                    row_with_values)
    when '02'
      row_operation(change_in_consent_required_fields(@row),
                    row_with_values)
    when '03'
      row_operation(change_in_opt_ins_required_fields,
                    row_with_values)
    when '04'
      row_operation(change_in_email_required_fields,
                    row_with_values)
    when '05'
      row_operation(account_close_required_fields,
                    row_with_values)
    end
  end

end
