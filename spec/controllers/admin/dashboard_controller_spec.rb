require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  let!(:admin) { create(:admin) }
  before(:each) { sign_in admin }

  it 'overview action' do
    get :overview
    expect(response.status).to eq(200)
    expect(response).to render_template('overview')
  end

end
