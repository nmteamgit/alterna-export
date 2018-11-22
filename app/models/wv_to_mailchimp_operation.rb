class WvToMailchimpOperation < ActiveRecord::Base
  include Filterable
  include WvToMailchimpOperationConfig

  serialize :data

  scope :to_be_processed, -> {where(status: nil)}
  scope :unsubscribed, -> {where(email_consent: 'N', opcode: '02')}
  scope :updates, -> {where("opcode in (?)", ['03','04'])}
  scope :new_contacts, -> {where(opcode: '01')}

  validates_presence_of :data, :mailchimp_list_type, :email, :opcode

  def details
    opcode.present? ? I18n.t("details.opcode.#{opcode}") : '-'
  end

  def self.email_present?(profile_email)
    WvToMailchimpOperation.all.map(&:email).uniq.include?(profile_email)
  end
end
