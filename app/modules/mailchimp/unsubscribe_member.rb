module Mailchimp
  class UnsubscribeMember
    attr_reader :status, :details

    def initialize(unsubscribe_obj)
      # MailchimpUnsubscribe object
      @obj = unsubscribe_obj
      @secrets = Rails.application.secrets.mailchimp
    end

    def unsubscribe!
      begin
        unsubscribe_member
      rescue Exception => e
        raise "Error: #{e}"
      end
    end

    def unsubscribe_member
      response = process_request
      if response.code == 200
        @status = 'success'
      else
        @status = 'failure'
      end
      @details = response.parsed_response
    end

    def process_request
      HTTParty.patch(
        member_unsubscribe_endpoint,
        basic_auth: basic_auth,
        body: unsubscribe_member_body_parameters,
        format: :json
      )
    end

    def unsubscribe_member_body_parameters
      {
        email_address: @obj.email,
        status: 'unsubscribed',
        merge_fields: { FNAME: @obj.data[:first_name],
                        LNAME: @obj.data[:last_name],
                        BUS_NAME: @obj.data[:business_name] }
      }.to_json
    end

    def member_unsubscribe_endpoint
      email_md5 = Digest::MD5.hexdigest(@obj.email)
      "#{@secrets['endpoint']}/lists/#{@secrets[@obj.mailchimp_list_type]['id']}/members/#{email_md5}"
    end

    def basic_auth
      {
        username: @secrets['username'],
        password: @secrets['password']
      }
    end
  end
end
