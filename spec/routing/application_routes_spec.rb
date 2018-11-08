require 'rails_helper'

context 'routes' do
  describe 'routes to application controller', type: :routing do
    it 'GET mailchimp_callback to application controller' do
      expect(get('/mailchimp_callback')).to route_to('application#mailchimp_callback')
    end
    it 'POST mailchimp_callback to application controller' do
      expect(post('/mailchimp_callback')).to route_to('application#mailchimp_callback')
    end
  end
end
