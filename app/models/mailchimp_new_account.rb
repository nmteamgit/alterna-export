class MailchimpNewAccount < ActiveRecord::Base
  include Filterable
  include MailchimpNewAccountConfig
  serialize :data

  validates_presence_of :email, :data, :mailchimp_list_type

  def self.create_record(params)
    create(email: params['data']['merges']['EMAIL'],
           data: params,
           mailchimp_list_type: MailchimpToWvOperation.get_list_type(
                                  params['data']['list_id']
                                )
          )
  end
end
