FactoryGirl.define do
  factory :mailchimp_to_wv_operation do
    data {}
    mailchimp_list_type 'Alterna_Savings'
    sequence (:email) { |n| "test_email#{n}@example.com"}
    opcode 11
    action_name 'profile'
  end
end
