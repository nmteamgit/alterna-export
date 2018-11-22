require 'rails_helper'

context 'mailchimp callback' do
  describe ApplicationController, type: :controller do
    it 'should be a valid POST request' do
      params = {'data' => {'wv_row_id' => '1', 'list_id' => 'abc123', 'merges' => {'EMAIL' => 'test@alternaexport.com'}}, 'type' => 'profile'}
      expect(post :mailchimp_callback, params: params).to be_success
    end

    it 'should be a valid GET request' do
      expect(get :mailchimp_callback).to be_success
    end
  end
end
