module SharedMethods
  def get_opcode_details(opcode, email_consent=nil)
    if opcode == '02'
      if email_consent == 'N'
        I18n.t("details.opcode.12")
      elsif email_consent == 'Y'
        I18n.t("details.opcode.14")
      end
    else
      I18n.t("details.opcode.#{opcode}")
    end
  end

  def get_dashboard_log_details(status, opcode, email_consent=nil)
    if status == 'SUCCESS'
      I18n.t("details.#{request_type}") + ' - ' + get_opcode_details(opcode,email_consent)
    else
      I18n.t("details.#{request_type}") + ' - ' + error
    end
  end

end
