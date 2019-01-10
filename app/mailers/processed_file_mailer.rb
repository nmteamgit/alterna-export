class ProcessedFileMailer < ApplicationMailer
  default from: 'info@alterna.com'
 
  def send_processed_file_status(file_name, status, scenario, user)
    @file_name = file_name
    @time = Time.now.utc.strftime("%B %d, %Y %H:%M %Z")
    @status = status
    @scenario = scenario # MV TO WV / WV TO MV
    mail(to: user.email, subject: "Notification Email – Transmitted Files Status - #{scenario} - #{@status}")
  end

end
