module CsvValidation

  def new_subscriber_required_fields
    [ AlternaExport::Application.config.CSV[:OP_CODE],
      AlternaExport::Application.config.CSV[:TIMESTAMP],
      AlternaExport::Application.config.CSV[:WV_ROW_ID],
      AlternaExport::Application.config.CSV[:EMAIL],
      AlternaExport::Application.config.CSV[:LNAME],
      AlternaExport::Application.config.CSV[:EMAIL_CONSENT],
      AlternaExport::Application.config.CSV[:OPT_INS],
      AlternaExport::Application.config.CSV[:LANGUAGE],
      AlternaExport::Application.config.CSV[:BENEFIT_TYPE],
      AlternaExport::Application.config.CSV[:CONSENT_DATE],
      AlternaExport::Application.config.CSV[:INHS_CODE],
      AlternaExport::Application.config.CSV[:BUS_TYPE]
    ]
  end

  def change_in_consent_required_fields(csv_row)
    required = [ AlternaExport::Application.config.CSV[:OP_CODE],
                 AlternaExport::Application.config.CSV[:TIMESTAMP],
                 AlternaExport::Application.config.CSV[:WV_ROW_ID],
                 AlternaExport::Application.config.CSV[:EMAIL],
                 AlternaExport::Application.config.CSV[:EMAIL_CONSENT]
               ]
    if csv_row[ AlternaExport::Application.config.CSV[:EMAIL_CONSENT] ] == 'Y'
      required += [ AlternaExport::Application.config.CSV[:OPT_INS],
                    AlternaExport::Application.config.CSV[:CONSENT_DATE]
                  ]
    end
    required
  end

  def change_in_opt_ins_required_fields
    [ AlternaExport::Application.config.CSV[:OP_CODE],
      AlternaExport::Application.config.CSV[:TIMESTAMP],
      AlternaExport::Application.config.CSV[:WV_ROW_ID],
      AlternaExport::Application.config.CSV[:EMAIL],
      AlternaExport::Application.config.CSV[:LNAME],
      AlternaExport::Application.config.CSV[:OPT_INS],
      AlternaExport::Application.config.CSV[:LANGUAGE],
      AlternaExport::Application.config.CSV[:BENEFIT_TYPE]
    ]
  end

  def change_in_email_required_fields
    [ AlternaExport::Application.config.CSV[:OP_CODE],
      AlternaExport::Application.config.CSV[:TIMESTAMP],
      AlternaExport::Application.config.CSV[:WV_ROW_ID],
      AlternaExport::Application.config.CSV[:EMAIL],
      AlternaExport::Application.config.CSV[:NEW_EMAIL]
    ]
  end

  def account_close_required_fields
    [ AlternaExport::Application.config.CSV[:OP_CODE],
      AlternaExport::Application.config.CSV[:TIMESTAMP],
      AlternaExport::Application.config.CSV[:WV_ROW_ID],
      AlternaExport::Application.config.CSV[:EMAIL]
    ]
  end
end
