require 'rails_helper'

describe RailsAdmin::Config::Sections do
  it 'dashboard log fields' do
    # List Fields
    list_fields = RailsAdmin.config(DashboardLog).list.fields
    [:status, :updated_at, :details, :email, :mailchimp_list_type].each do |list_field|
      expect(list_fields.detect { |f| f.name == list_field }).to be_visible
    end

    # Show Fields
    show_fields = RailsAdmin.config(DashboardLog).show.fields
    [:status_code, :email, :opcode, :mailchimp_list_type, :request_type, :error_message, :filename, :created_at, :updated_at, :request_params, :response_params].each do |show_field|
      expect(show_fields.detect { |f| f.name == show_field }).to be_visible
    end
  end
end
