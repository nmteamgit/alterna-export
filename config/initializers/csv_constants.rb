

AlternaExport::Application.config.CSV = { OP_CODE: 'op_code',
                                          TIMESTAMP: 'timestamp',
                                          WV_ROW_ID: 'wv_row_id',
                                          EMAIL: 'email',
                                          FNAME: 'fname',
                                          LNAME: 'lname',
                                          EMAIL_CONSENT: 'email_consent',
                                          OPT_INS: 'opt_ins',
                                          LANGUAGE: 'language',
                                          BENEFIT_TYPE: 'benefit_type',
                                          INHS_CODE: 'inhs_code',
                                          CONSENT_DATE: 'consent_date',
                                          BUSINESS_TYPE: 'business_type',
                                          NEW_EMAIL: 'new_email',
                                          BUSINESS_NAME: 'business_name'
                                        }
AlternaExport::Application.config.CSV_HEADER = [AlternaExport::Application.config.CSV[:OP_CODE],
                                                AlternaExport::Application.config.CSV[:TIMESTAMP],
                                                AlternaExport::Application.config.CSV[:WV_ROW_ID],
                                                AlternaExport::Application.config.CSV[:EMAIL],
                                                AlternaExport::Application.config.CSV[:FNAME],
                                                AlternaExport::Application.config.CSV[:LNAME],
                                                AlternaExport::Application.config.CSV[:EMAIL_CONSENT],
                                                AlternaExport::Application.config.CSV[:OPT_INS],
                                                AlternaExport::Application.config.CSV[:LANGUAGE],
                                                AlternaExport::Application.config.CSV[:BENEFIT_TYPE],
                                                AlternaExport::Application.config.CSV[:INHS_CODE],
                                                AlternaExport::Application.config.CSV[:CONSENT_DATE],
                                                AlternaExport::Application.config.CSV[:BUSINESS_TYPE],
                                                AlternaExport::Application.config.CSV[:NEW_EMAIL],
                                                AlternaExport::Application.config.CSV[:BUSINESS_NAME]
                                              ]
