# mailchimp unsubscribe logs
class MailchimpUnsubscribe < ApplicationRecord
  include MailchimpUnsubscribeConfig
  include Filterable
  # TODO: Possiblilty for changing list name, Move this configuration to secret.yml
  LIST_TYPES = { 'savings' => 'Alterna_Savings', 'bank' => 'Alterna_Bank' }.freeze

  serialize :details
  serialize :data
  before_save :unsubscribe_member_and_set_status

  def unsubscribe_member_and_set_status
    unsubscribe_member = Mailchimp::UnsubscribeMember.new(self)
    unsubscribe_member.unsubscribe!
    self.status = unsubscribe_member.status
    self.details = unsubscribe_member.details
  end

  class << self
    # unsubscribe from both Alterna_Bank and Alterna_Savings list
    def unsubscribe_all!(params)
      [unsubscribe!(params, 'bank'), unsubscribe!(params, 'savings')]
    end

    def unsubscribe!(params, list_name = nil)
      list_type_name = list_name || params[:list_type]
      list_type = get_list_type(list_type_name)
      obj = new(email: params[:email], mailchimp_list_type: list_type, data: params.to_hash) # save record with form request
      obj.save!
      obj
    end

    def get_list_type(list_name)
      LIST_TYPES[list_name]
    end
  end
end
