class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, only: :mailchimp_callback

  def mailchimp_callback
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

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || rails_admin_path
  end

  private

  def callback_params
    params.permit(:type, :fired_at, data: [:new_email, :old_email, :list_id, merges: [:EMAIL, :FNAME, :LNAME, :WV_ROW_ID, :INHS_CODE, :BF_TYPE, :BUS_TYPE, :BUS_NAME, :TIMESTAMP, :C_DATE, :LANGUAGE, :INTERESTS]])
  end

end
