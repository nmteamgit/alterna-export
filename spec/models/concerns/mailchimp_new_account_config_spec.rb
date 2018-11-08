require 'rails_helper'

describe RailsAdmin::Config::Sections do
  it 'Mailchimp New Account Fields' do
    # List Fields
    list_fields = RailsAdmin.config(MailchimpNewAccount).list.fields
    [:updated_at, :email, :mailchimp_list_type].each do |list_field|
      expect(list_fields.detect { |f| f.name == list_field }).to be_visible
    end

    # Show Fields
    show_fields = RailsAdmin.config(MailchimpNewAccount).show.fields
    [:email, :mailchimp_list_type, :created_at, :updated_at, :data].each do |show_field|
      expect(show_fields.detect { |f| f.name == show_field }).to be_visible
    end
  end
end
