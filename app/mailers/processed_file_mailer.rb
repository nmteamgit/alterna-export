class ProcessedFileMailer < ApplicationMailer
  default from: 'info@alterna.com'
 
  def send_processed_file_status(file_name, status, scenario)
    @file_name = file_name
    @time = Time.now.utc.strftime("%B %d, %Y %H:%M %Z")
    @status = status
    @scenario = scenario # MV TO WV / WV TO MV
    Admin.where(send_status: true).each do |user|
      mail(to: user.email, subject: "Notification Email – Transmitted Files Status - #{scenario} - #{@status}")
    end
  end

end
