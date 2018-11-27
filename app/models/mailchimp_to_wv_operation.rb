class MailchimpToWvOperation < ActiveRecord::Base
  include Filterable
  include MailchimpToWvOperationConfig
  include SharedMethods
  serialize :data

  scope :to_be_processed, -> (list_type) {where(status: nil, mailchimp_list_type: list_type)}
  scope :unsubscribed, -> {where(email_consent: 'N', opcode: '12')}
  scope :updates, -> {where("opcode in (?)", ['11','13'])}
  scope :resubscribe, -> {where(opcode: '14')}

  validates_presence_of :data, :mailchimp_list_type, :email, :opcode, :action_name

  def op_code
    if data['type'] == 'profile'
      '11'
    elsif data['type'] == 'unsubscribe'
      '12'
    elsif data['type'] == 'upemail'
      '13'
    elsif data['type'] == 'subscribe'
      '14'
    end
  end

  def email_consent_value
    data['type'] == 'unsubscribe' ? 'N' : 'Y'
  end

  def interests
    result = []
    if ['11', '12', '14'].include?(opcode) && data['data']['merges']['INTERESTS'].present?
      data['data']['merges']['INTERESTS'].split(',').each do |name|
        result << Rails.application.secrets.mailchimp[mailchimp_list_type]['interests'][name.strip]
      end
    end
    result.present? ? result.join('|') : ""
  end

  def self.create_record(params)
    if params['type']=='upemail'
      record = new(action_name: params['type'],
                      mailchimp_list_type: MailchimpToWvOperation.get_list_type(
                        params['data']['list_id']
                      )
                  )
    else
      record = find_or_initialize_by(
                        wv_row_id: params['type']=='upemail' ? nil : params['data']['merges']['WV_ROW_ID'],
                        status: nil,
                        action_name: params['type'],
                        mailchimp_list_type: MailchimpToWvOperation.get_list_type(
                                        params['data']['list_id']
                                      )
                                  )
    end
    record.data = params
    record.email = params['type']=='upemail' ? params['data']['new_email'] : params['data']['merges']['EMAIL']
    record.opcode = record.op_code
    record.email_consent = record.email_consent_value
    record.details = record.get_opcode_details(record.op_code)
    record.save!
  end

  def self.get_list_type(list_id)
    list = {}
    AlternaExport::Application.config.MAILCHIMP_LIST_TYPES.each do |list_type|
      list[list_type] = Rails.application.secrets.mailchimp[list_type]['id']
    end
    list.key(list_id)
  end

  def get_wv_row_id_for_upemail
    profile_records = MailchimpToWvOperation.where(action_name: 'profile')
    record = profile_records.where(email: data['data']['new_email']).last || profile_records.where(email: data['data']['old_email']).last

    if record.present?
      record.data['data']['merges']['WV_ROW_ID']
    end
  end
end
