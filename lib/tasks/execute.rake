namespace :execute do

  task process_wv_csv_file: :environment do
    desc %Q{ >> Read the ftp file, Write to DB, Process to mailchimp}
    AlternaExport::Application.config.MAILCHIMP_LIST_TYPES.each do |list_name|
      data_filepaths = Ftp.new(list_name).fetch_data_files # fetch files from FTP
      data_filepaths.each do |amv_file_path|
        csv_parser = WvCsvParser.new({listname: list_name, filepath: amv_file_path}).perform # parse csv and write to DB
        processed_file_path = CsvGenerator.new.generate_processed_file(
                                File.basename(amv_file_path),
                                csv_parser[:read_count],
                                csv_parser[:success_count],
                                csv_parser[:validation_errors]
                              ) # generate processed file
        Ftp.new(list_name).write( processed_file_path,
                                  Rails.application.secrets.wv_to_mv_read_filepath[list_name]+'processed_'+File.basename(amv_file_path)
                                ) # write processed file to FTP
        Ftp.new(list_name).archive(File.basename(amv_file_path)) # move generated file to Archived folder
      end
    end
    Mailchimp::DataProcessor.new.process #write to mailchimp
  end

  task mailchimp_callback: :environment do
    desc %Q{ >> Read from DB, create csv file, put in ftp}
    AlternaExport::Application.config.MAILCHIMP_LIST_TYPES.each do |list_name|
      file = CsvGenerator.new.generate_mailchimp_trigger_file(list_name) # create csv file
      Ftp.new(list_name).write( file,
                                Rails.application.secrets.mv_to_wv_write_filepath[list_name]+File.basename(file)
                              ) # write file to FTP
    end
  end

end
