class ReminderConfigurationController < ApplicationController
  unloadable

  layout 'admin'

  before_filter :require_admin

  def edit
    @configuration = ReminderConfiguration.instance
  end

  def update
    @configuration = ReminderConfiguration.instance
    if @configuration.update_attributes permitted_conf_params
      redirect_to edit_reminder_configuration_url
    else
      render action: 'edit', layout: 'admin'
    end
  end

  private

  def permitted_conf_params
    params.required(:reminder_configuration).permit(
      :days, :issue_status_selector, :project_selector, :tracker_selector, :send_to_author,
      :send_to_assigned_to, :send_to_watcher, :send_to_custom_user
    )
  end
end
