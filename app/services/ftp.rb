class Ftp
  require 'net/ftp'
  require 'net/sftp'

  def initialize(list_type)
    @list_type = list_type
    @ftp_server_host_name = Rails.application.secrets.ftp_module_host_name
    @ftp_login = Rails.application.secrets.ftp_module_login
    @ftp_password = Rails.application.secrets.ftp_module_password
    @ftp_port = Rails.application.secrets.ftp_port
    @file_read_path = Rails.application.secrets.wv_to_mv_read_filepath[@list_type]
    @app_import_path = Rails.application.secrets.app_csv_import_path
    @app_export_path = Rails.application.secrets.app_csv_export_path
  end

  def fetch_data_files (type=nil)
    begin
      data_filepaths = []
      #data_filepaths << @app_import_path+"wv_to_amv_20191007_060518.csv" if type == 'Alterna_Bank'
      Net::SFTP.start(@ftp_server_host_name, @ftp_login, password: @ftp_password, port: @ftp_port) do |sftp|
        files = sftp.dir.glob(@file_read_path, "wv_to_amv_*")
        files.each do |file|
          amw_file_path = @app_import_path+file.name
          sftp.download!(@file_read_path+file.name, amw_file_path)
          data_filepaths << amw_file_path
        end
      end
    rescue Exception => e
      log_error(e.message, DashboardLog::FTP_READ)
    end
    return data_filepaths
  end

  def fetch_missing_mv_to_wv
    data_filepaths = []
    ((Date.today - 1.month)..Date.today).each do |date|
      formatted_date = date.strftime("%Y%m%d")
      entries = Dir.entries(Rails.application.secrets.app_csv_export_path).select {|f| f.include?(formatted_date)}
      if entries.count < 2
        data_filepaths << formatted_date
      end
    end
    data_filepaths
  end


  def fetch_reprocessing_data_files
    data_filepaths = []
    Dir.glob(@app_import_path+'processed*.csv').each do |file_name|
      data_filepaths << file_name
    end
    puts data_filepaths
    return data_filepaths
  end

  def write(source_path, destination_path)
    begin
      Net::SFTP.start(@ftp_server_host_name, @ftp_login, password: @ftp_password, port: @ftp_port) do |sftp|
        sftp.upload!(source_path, destination_path)
      end
      #File.delete(source_path) if File.exist?(source_path) # delete source file after upload
    rescue Exception => e
      log_error(e.message, DashboardLog::FTP_WRITE)
    end
  end

  def archive(filename)
    begin
      Net::SFTP.start(@ftp_server_host_name, @ftp_login, password: @ftp_password, port: @ftp_port) do |sftp|
        sftp.rename(@file_read_path+filename, "#{@file_read_path}Archived/#{filename}")
      end
    rescue Exception => e
      log_error(e.message, DashboardLog.FTP_ARCHIVE)
    end
  end

  def log_error(message, action_name)
    Rails.logger.error message
    DashboardLog.create!(error_message: message, mailchimp_list_type: @list_type,
                         request_type: action_name, status: 'FAILURE')
  end
end
