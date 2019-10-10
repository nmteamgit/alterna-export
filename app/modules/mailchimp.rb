module Mailchimp
  class DataProcessor
    require 'digest'

    def initialize()
      @to_be_processed = WvToMailchimpOperation.to_be_processed
      @secrets = Rails.application.secrets.mailchimp
    end

    def process
      begin
        @to_be_processed.each do |data|
          process_row(data)
        end
      rescue Exception => e
        raise "Error: #{e.message}" # TODO
      end
    end

    def process_row(data)
      data_row = data.data
      case data_row['op_code']
      when '01'
        response = add_new_subscriber(data)
      when '02'
        response = change_in_consent(data)
      when '03'
        response = change_in_opt_ins(data)
      when '04'
        response = email_change(data)
      when '05'
        response = account_close(data)
      else
        # TODO add to log - no action has taken
      end
      handle_response(data, response, delete_request = data_row['op_code']=='05' ? true : false)
    end

    def handle_response(data, response, delete_request=false)
      if (delete_request && response.code == 204) || response.code == 200
        data.update_attributes(status: 'SUCCESS')
        DashboardLog.create_to_mailchimp_record(data, response, status='SUCCESS')
      else
        DashboardLog.create_to_mailchimp_record(data, response, status='FAILURE')
        data.update_attributes(status: 'FAILURE')
      end
    end

    def add_new_subscriber(data)
      # Mailchimp api call to add new subscriber
      HTTParty.post(
        new_subscriber_endpoint(data.mailchimp_list_type),
        basic_auth: basic_auth,
        body: new_subscriber_body_parameters(data).to_json,
        format: :json
      )
    end

    def change_in_consent(data)
      response = HTTParty.patch(
        change_in_subscriber_endpoint(data),
        basic_auth: basic_auth,
        body: change_in_consent_body_parameters(data).to_json,
        format: :json
      )
      if response.code == 404
        data.data['op_code'] = '01'
        return add_new_subscriber(data)
      end
      return response
    end

    def change_in_opt_ins(data)
      HTTParty.patch(
        change_in_subscriber_endpoint(data),
        basic_auth: basic_auth,
        body: change_in_opt_ins_body_parameters(data).to_json,
        format: :json
      )
    end

    def email_change(data)
      HTTParty.patch(
        change_in_subscriber_endpoint(data),
        basic_auth: basic_auth,
        body: change_in_email_body_parameters(data).to_json,
        format: :json
      )
    end

    def account_close(data)
      HTTParty.delete(
        change_in_subscriber_endpoint(data),
        basic_auth: basic_auth,
        format: :json
      )
    end

    private

    def basic_auth
      {
        username: @secrets['username'],
        password: @secrets['password']
      }
    end

    def email_consent(value)
      # returns mailchimp status name based on email consent value(Y/N)
      value == 'Y' ? 'subscribed' : 'unsubscribed'
    end

    def opt_ins(value, list_type)
      # eg: '01|02'
      interests = {}
      all_interest_codes = ['01', '02', '03']
      opt_in_codes = value.split('|')
      all_interest_codes.each do |i_code|
        interests[@secrets[list_type]['interests'][i_code]] = opt_in_codes.include?(i_code)
      end
      interests
    end

    def new_subscriber_endpoint(list_type)
      "#{@secrets['endpoint']}/lists/#{@secrets[list_type]['id']}/members"
    end

    def change_in_subscriber_endpoint(data)
      data_row = data.data
      list_type = data.mailchimp_list_type
      email = data_row['email']
      email_md5 = Digest::MD5.hexdigest(email)
      "#{@secrets['endpoint']}/lists/#{@secrets[list_type]['id']}/members/#{email_md5}"
    end

    def new_subscriber_body_parameters(data)
      data_row = data.data
      {email_address: data_row['email'],
       status: email_consent(data_row['email_consent']),
       merge_fields: {'FNAME': data_row['fname'],
                      'LNAME': data_row['lname'],
                      'WV_ROW_ID': data_row['wv_row_id'],
                      'INHS_CODE': data_row['inhs_code'] || '',
                      'BF_TYPE': data_row['benefit_type'],
                      'BUS_TYPE': data_row['business_type'] || '',
                      'TIMESTAMP': data_row['timestamp'],
                      'C_DATE': data_row['consent_date'],
                      'BUS_NAME': data_row['business_name'] || '',
                      'LANGUAGE': data_row['language']},
       interests: opt_ins(data_row['opt_ins'], data.mailchimp_list_type),
       language: data_row['language']
      }
    end

    def change_in_consent_body_parameters(data)
      data_row = data.data
      params = {email_address: data_row['email'],
             status: email_consent(data_row['email_consent'])}
      if data_row['email_consent'] == 'Y'
        params[:merge_fields] = {'C_DATE': data_row['consent_date']}
        params[:interests] = opt_ins(data_row['opt_ins'], data.mailchimp_list_type)
      end
      params
    end

    def change_in_opt_ins_body_parameters(data)
      data_row = data.data
      {email_address: data_row['email'],
       status: email_consent(data_row['email_consent']),
       merge_fields: {'FNAME': data_row['fname'],
                      'LNAME': data_row['lname'],
                      'WV_ROW_ID': data_row['wv_row_id'],
                      'INHS_CODE': data_row['inhs_code'] || '',
                      'BF_TYPE': data_row['benefit_type'],
                      'BUS_TYPE': data_row['business_type'] || '',
                      'TIMESTAMP': data_row['timestamp'],
                      'C_DATE': data_row['consent_date'] || '',
                      'BUS_NAME': data_row['business_name'] || '',
                      'LANGUAGE': data_row['language']},
       interests: opt_ins(data_row['opt_ins'], data.mailchimp_list_type),
       language: data_row['language']
      }
    end

    def change_in_email_body_parameters(data)
      data_row = data.data
      {email_address: data_row['new_email']}
    end

  end
end
