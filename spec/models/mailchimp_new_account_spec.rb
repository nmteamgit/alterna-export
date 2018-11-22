require 'rails_helper'

describe MailchimpNewAccount do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:data) }
    it { is_expected.to validate_presence_of(:mailchimp_list_type) }
  end
end
