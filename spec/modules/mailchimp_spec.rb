require 'rails_helper'

describe Mailchimp do

  it 'should be able to return correct new subscriber endpoint' do
    endpoint = Mailchimp::DataProcessor.new.send(:new_subscriber_endpoint, 'Alterna_Savings')
    expect(endpoint).to eq('https://api.mailchimp.com/3.0/lists/abc123/members')
  end

  it 'should be able to return correct change in subscriber endpoint' do
    data = FactoryGirl.create(:wv_to_mailchimp_operation, data: {'email' => 'test@cybrilla.com'}, email: 'test@cybrilla.com')
    md5_value = Digest::MD5.hexdigest(data.data['email'])
    expected_value = "https://api.mailchimp.com/3.0/lists/abc123/members/#{md5_value}"
    endpoint = Mailchimp::DataProcessor.new.send(:change_in_subscriber_endpoint, data)
    expect(endpoint).to eq(expected_value)
  end

  it 'should be able to return correct opt in codes based on given value' do
    given_value = "01|02"
    expected_result = {'abc'=>true, 'def'=>true, 'ghi'=>false}
    interests = Mailchimp::DataProcessor.new.send(:opt_ins, given_value, 'Alterna_Savings')
    expect(interests).to eq(expected_result)
  end

  it 'should be able to return email consent based on value given' do
    expect(Mailchimp::DataProcessor.new.send(:email_consent, 'Y')).to eq('subscribed')
    expect(Mailchimp::DataProcessor.new.send(:email_consent, 'N')).to eq('unsubscribed')
    expect(Mailchimp::DataProcessor.new.send(:email_consent, nil)).to eq('unsubscribed')
  end

  it 'should be able to return correct basic auth format' do
    expect(Mailchimp::DataProcessor.new.send(:basic_auth)).to eq({username: 'xxx', password: 'xyz-us10'})
  end

  describe 'event body parameters' do
    before :all do
      @current_time = Time.zone.now
      data_row = {'email' => 'test@cybrilla.com', 'fname' => 'test1', 'lname' => 'test2',
                  'email_consent' => 'Y', 'wv_row_id' => '1', 'inhs_code' => '123',
                  'benefit_type' => 'business', 'business_type' => 'test', 'business_name' => 'test',
                  'timestamp' => @current_time, 'consent_date' => @current_time,
                  'language' => 'en', 'opt_ins' => '01|02', 'new_email' => 'test123@cybrilla.com'}
      @data = FactoryGirl.create(:wv_to_mailchimp_operation, data: data_row, mailchimp_list_type: 'Alterna_Savings', email: 'test@cybrilla.com')
    end

    it 'should be able to return new subscriber body parameters based on given data' do
      result = Mailchimp::DataProcessor.new.send(:new_subscriber_body_parameters, @data)
      expected_result = {email_address: 'test@cybrilla.com', status: 'subscribed',
                         merge_fields: {FNAME: 'test1', LNAME: 'test2',
                                        WV_ROW_ID: '1', INHS_CODE: '123',
                                        BF_TYPE: 'business', BUS_TYPE: 'test',
                                        TIMESTAMP: @current_time,
                                        C_DATE: @current_time,
                                        BUS_NAME: 'test',
                                        LANGUAGE: 'en'},
                        interests: {'abc'=>true, 'def'=>true, 'ghi'=>false},
                        language: 'en'}
      expect(result).to eq(expected_result)
    end

    it 'should be able to return change in consent body parameters based on given data' do
      result = Mailchimp::DataProcessor.new.send(:change_in_consent_body_parameters, @data)
      expected_result = {email_address: 'test@cybrilla.com', status: 'subscribed',
                         merge_fields: {C_DATE: @current_time},
                         interests: {'abc'=>true, 'def'=>true, 'ghi'=>false}}
      expect(result).to eq(expected_result)
    end

    it 'should be able to return change in opt ins body parameters based on given data' do
      result = Mailchimp::DataProcessor.new.send(:change_in_opt_ins_body_parameters, @data)
      expected_result = {email_address: 'test@cybrilla.com', status: 'subscribed',
                         merge_fields: {FNAME: 'test1', LNAME: 'test2',
                                        WV_ROW_ID: '1', INHS_CODE: '123',
                                        BF_TYPE: 'business', BUS_TYPE: 'test',
                                        BUS_NAME: 'test',
                                        TIMESTAMP: @current_time,
                                        C_DATE: @current_time,
                                        LANGUAGE: 'en'},
                        interests: {'abc'=>true, 'def'=>true, 'ghi'=>false},
                        language: 'en'}
      expect(result).to eq(expected_result)
    end

    it 'should be able to return change in email body parameters based on given data' do
      result = Mailchimp::DataProcessor.new.send(:change_in_email_body_parameters, @data)
      expected_result = {email_address: 'test123@cybrilla.com'}
      expect(result).to eq(expected_result)
    end
  end

end
