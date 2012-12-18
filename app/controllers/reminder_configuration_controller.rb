class ReminderConfigurationController < ApplicationController
  unloadable

  layout 'admin'

  before_filter :require_admin

  def edit
    @configuration = ReminderConfiguration.instance
  end

  def update
    @configuration = ReminderConfiguration.instance
    if @configuration.update_attributes(params[:reminder_configuration])
      redirect_to edit_reminder_configuration_url
    else
      render :action => "edit", :layout => "admin"
    end
  end
end
