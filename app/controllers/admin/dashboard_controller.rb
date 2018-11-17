require 'rails_admin/main_controller'
module RailsAdmin
  class Admin::DashboardController < RailsAdmin::ApplicationController
    include ActionView::Helpers::TextHelper
    include RailsAdmin::MainHelper
    include RailsAdmin::ApplicationHelper
    include RailsAdmin::Engine.routes.url_helpers

    layout 'layouts/rails_admin/application'

    def overview
      wv_records = params[:scope].present? ? WvToMailchimpOperation.send(params[:scope]) : WvToMailchimpOperation.all
      mc_records = params[:scope].present? ? MailchimpToWvOperation.send(params[:scope]) : MailchimpToWvOperation.all
      mc_accounts = params[:scope].present? ? MailchimpNewAccount.send(params[:scope]) : MailchimpNewAccount.all
      processed_files = params[:scope].present? ? ProcessedFile.send(params[:scope]) : ProcessedFile.all

      @wv_updates_count = wv_records.updates.count
      @wv_new_contacts_count = wv_records.new_contacts.count
      @wv_unsubscribe_count = wv_records.unsubscribed.count

      @processed_files_wv_to_mv_count = processed_files.mv_to_wv.count
      @processed_files_mv_to_wv_count = processed_files.wv_to_mv.count
      @processed_files_success_count = processed_files.success.count
      @processed_files_failed_count = processed_files.failed.count
      @processed_files_count = processed_files.failed.count

      @mc_updates_count = mc_records.updates.count
      @mc_unsubscribe_count = mc_records.unsubscribed.count
      @mc_resubscribe_count = mc_records.resubscribe.count
      @mc_new_accounts_count = mc_accounts.count
    end

  end
end