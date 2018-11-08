require 'rails_helper'

describe MailchimpToWvOperation do
  describe '.op_code' do
    it 'should be able to return opcode based on mailchimp type profile' do
      record = FactoryGirl.create(:mailchimp_to_wv_operation, data: {'type' => 'profile'})
      expect(record.op_code).to eq('11')
    end
    it 'should be able to return opcode based on mailchimp type unsubscribe' do
      record = FactoryGirl.create(:mailchimp_to_wv_operation, data: {'type' => 'unsubscribe'})
      expect(record.op_code).to eq('12')
    end
    it 'should be able to return opcode based on mailchimp type upemail' do
      record = FactoryGirl.create(:mailchimp_to_wv_operation, data: {'type' => 'upemail'})
      expect(record.op_code).to eq('13')
    end
  end

  describe '.email_consent_value' do
    it 'should be able to return N if member unsubscribed in mailchimp' do
      record = FactoryGirl.create(:mailchimp_to_wv_operation, data: {'type' => 'unsubscribe'})
      expect(record.email_consent_value).to eq('N')
    end
    it 'should be able to return empty string if member not unsubscribed in mailchimp' do
      record = FactoryGirl.create(:mailchimp_to_wv_operation, data: {'type' => 'profile'})
      expect(record.email_consent_value).to eq('Y')
    end
  end

  describe '.interests' do
    it 'should return interest codes if member opted for multiple interests in mailchimp' do
      record = FactoryGirl.create(:mailchimp_to_wv_operation, opcode: 11, data: {'type' => 'profile', 'data' => {'merges' => {'INTERESTS' => 'E-newsletter, Alterna news and events'}}})
      expect(record.interests).to eq('02|03')
    end
    it 'should return interest codes if member opted for single interest in mailchimp' do
      record = FactoryGirl.create(:mailchimp_to_wv_operation, opcode: 11, data: {'type' => 'profile', 'data' => {'merges' => {'INTERESTS' => 'E-newsletter'}}})
      expect(record.interests).to eq('02')
    end
  end

  describe 'create_record' do
    it 'should create record based on parameters provided' do
      params = {'data' => {'wv_row_id' => '1', 'list_id' => 'abc123', 'merges' => {'EMAIL' => 'test@alternaexport.com'}}, 'type' => 'profile'}
      expect(MailchimpToWvOperation.create_record(params)).to eq(true)
    end
    it 'should create record for upemail' do
      params = {'data' => {'list_id' => 'abc123', 'new_email' => 'test1@alternaexport.com', 'old_email' => 'test@alternaexport.com'}, 'type' => 'upemail'}
      expect(MailchimpToWvOperation.create_record(params)).to eq(true)
    end
  end

  describe 'get_list_type' do
    it 'should return list name based on list id of mailchimp' do
      expect(MailchimpToWvOperation.get_list_type('abc456')).to eq('Alterna_Bank')
    end
  end

end
