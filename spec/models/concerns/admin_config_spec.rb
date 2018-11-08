require 'rails_helper'

describe RailsAdmin::Config::Sections do

  it 'admin fields' do
    # Create New Admin Fields
    create_fields = RailsAdmin.config(Admin).create.fields
    [:name, :email, :password, :role].each do |create_field|
      expect(create_fields.detect { |f| f.name == create_field }).to be_visible
    end

    # Edit Admin Fields
    edit_fields = RailsAdmin.config(Admin).edit.fields
    [:name, :email, :password, :role].each do |edit_field|
      expect(edit_fields.detect { |f| f.name == edit_field }).to be_visible
    end

    # List Admin Fields
    list_fields = RailsAdmin.config(Admin).list.fields
    [:name, :email, :role].each do |list_field|
      expect(list_fields.detect { |f| f.name == list_field }).to be_visible
    end
  end
end
