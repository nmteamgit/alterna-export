class ApplicationController < ActionController::Base

  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, only: %i[mailchimp_callback mailchimp_unsubscribe]


  def mailchimp_callback
    logger = Logger.new("#{Rails.root}/log/mailchimp_callback.log")
    logger.info(callback_params)
    begin
      # push data to db.
      if request.post?
        if callback_params['type'] == 'subscribe' and !WvToMailchimpOperation.email_present?(callback_params['data']['merges']['EMAIL'])
          MailchimpNewAccount.create_record(callback_params)
        else
          MailchimpToWvOperation.create_record(callback_params)
          DashboardLog.log_mailchimp_callback(callback_params, nil, 'SUCCESS')
        end
      end
      render plain: 'success'
    rescue Exception => e
      DashboardLog.log_mailchimp_callback(callback_params, e.message, 'FAILURE')
    end
  end

  def enable_admin_mailer
    admin_user = Admin.find_by(email: params[:email])
    if admin_user
      if params[:send_status]
        admin_user.update_attributes(send_status: true)
      else
        admin_user.update_attributes(send_status: false)
      end
    end
    redirect_to "/admin/admin", flash: {:notice => "Success" }
  end


  def mailchimp_unsubscribe
    if request.post?
      if unsubscribe_params[:list_type] == 'both'
        @unsubscribes = MailchimpUnsubscribe.unsubscribe_all!(unsubscribe_params)
      else
        @unsubscribe = MailchimpUnsubscribe.unsubscribe!(unsubscribe_params)
      end
      if @unsubscribes&.any?{ |unsubscribe| unsubscribe.status == 'failure' } || @unsubscribe&.status == 'failure'
        build_unsubscribe_error_messages
      end
      @unsubscribed_lists ||= Array.wrap(@unsubscribe || @unsubscribes).map{|list| format_list_name(list.mailchimp_list_type)}
      @subscribe_status ||= 'success'
      # push response data to mailchimp updates
      create_mailchimp_to_wv_operation_record
      redirect_to :thank_you, flash: {:subscribe_status => @subscribe_status, unsubscribed_lists: @unsubscribed_lists }
    end
  end

  def thank_you
    render layout: false
  end


  def after_sign_in_path_for(resource)
    stored_location_for(resource) || rails_admin_path
  end

  private

  def callback_params
    params.permit(:type, :fired_at, data: [:wv_row_id, :new_email, :old_email, :list_id, merges: [:EMAIL, :FNAME, :LNAME, :WV_ROW_ID, :INHS_CODE, :BF_TYPE, :BUS_TYPE, :BUS_NAME, :TIMESTAMP, :C_DATE, :LANGUAGE, :INTERESTS]])
  end


  def unsubscribe_params
    params.permit(:list_type, :first_name, :last_name, :business_name, :email)
  end

  def build_unsubscribe_error_messages
    #  One Unsubscribe Success and One Unsubscribe failure
    if @unsubscribes && !@unsubscribes.all? { |un| un.status == 'failure' }
      unsubscribed = @unsubscribes.detect{|un| un.status == 'success'}
      unsubscribed_list_type = format_list_name(unsubscribed.mailchimp_list_type)
      @subscribe_status = 'one_success_and_one_failure'
      @unsubscribed_lists = [unsubscribed_list_type]
    else
      @subscribe_status = 'failure'
    end
  end

  def create_mailchimp_to_wv_operation_record
    Array.wrap(@unsubscribe || @unsubscribes).each do |un|
      if un.status == 'success'
        MailchimpToWvOperation.create_record(build_response_params(un))
      end
    end
  end

  def build_response_params(data)
    HashWithIndifferentAccess.new({type: 'unsubscribe', fired_at: data.details['last_changed'], data: { list_id: data.details['list_id'], merges: data.details['merge_fields'].merge!({ EMAIL: data.details['email_address'], INTERESTS: interests(data) }) } })
  end

  # find interests name from interests id Hash
  def interests(data)
    interests_list = data.details['interests']
    return '' unless interests_list
    interests_config = Rails.application.secrets.mailchimp[data.mailchimp_list_type]['interests']
    interests_names =[]
    interests_list.keys.each do |interest_id|
      opcode = interests_config.key(interest_id)
      interests_names << interests_config.key(opcode)
    end
    interests_names.compact.join(',')
  end
end
