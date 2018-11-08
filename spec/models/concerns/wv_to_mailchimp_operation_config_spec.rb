require 'rails_helper'

describe RailsAdmin::Config::Sections do
  it 'wv to mailchimp operation fields' do
    # List Fields
    list_fields = RailsAdmin.config(WvToMailchimpOperation).list.fields
    [:updated_at, :details, :email, :mailchimp_list_type].each do |list_field|
      expect(list_fields.detect { |f| f.name == list_field }).to be_visible
    end
  end
end
