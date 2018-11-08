FactoryGirl.define do
  factory :wv_to_mailchimp_operation do
    data {}
    mailchimp_list_type 'Alterna_Savings'
    sequence (:email) { |n| "test_email#{n}@example.com"}
    opcode 01
  end
end
