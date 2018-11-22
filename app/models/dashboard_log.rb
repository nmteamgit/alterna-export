class DashboardLog < ActiveRecord::Base
  include SharedMethods
  include Filterable
  include DashboardLogConfig

  serialize :response_params
  serialize :request_params

  TO_MAILCHIMP = 'TO_MAILCHIMP'
  FROM_MAILCHIMP = 'FROM_MAILCHIMP'
  FTP_READ = 'FTP_READ'
  FTP_WRITE = 'FTP_WRITE'
  FTP_ARCHIVE = 'FTP_ARCHIVE'

  validates_presence_of :opcode, :email, :response_params, if: :mailchimp_action?
  validates_presence_of :error_message, if: :ftp_action?
  validates_presence_of :status, :request_type, :mailchimp_list_type

  def mailchimp_action?
    [TO_MAILCHIMP, FROM_MAILCHIMP].include?(request_type)
  end

  def ftp_action?
    [FTP_READ, FTP_WRITE, FTP_ARCHIVE].include?(request_type)
  end

  def error
    if request_type == TO_MAILCHIMP
      "#{response_params['title']} | #{response_params['detail']}"
    elsif ftp_action? || request_type == FROM_MAILCHIMP
      error_message
    end
  end

  def self.create_to_mailchimp_record(data, response, status)
    record = new(response_params: response.parsed_response,
           status_code: response.code,
           mailchimp_list_type: data.mailchimp_list_type,
           request_type: TO_MAILCHIMP,
           request_params: data.data,
           filename: data.filename,
           status: status,
           email: data['email']
           )
    record.opcode = data.data['op_code']
    record.details = record.get_dashboard_log_details(status, data.data['op_code'], data.data['email_consent'])
    record.save
  end

  def self.log_mailchimp_callback(response, exception, status)
    opcode_value = get_opcode_from_callback_action(response['type'])
    record = new(error_message: exception,
           response_params: response,
           mailchimp_list_type: MailchimpToWvOperation.get_list_type(
                                             response['data']['list_id']),
           request_type: FROM_MAILCHIMP,
           status: status,
           email: response['type']=='upemail' ? response['data']['new_email'] : response['data']['merges']['EMAIL']
          )
    record.opcode = opcode_value
    record.details = record.get_dashboard_log_details(status, opcode_value)
    record.save
  end

  def self.get_opcode_from_callback_action(action_type)
    case action_type
    when 'profile'
      '11'
    when 'unsubscribe'
      '12'
    when 'subscribe'
      '14'
    when 'upemail'
      '13'
    end
  end

end
