class AddUseDueDayToReminderConfiguration < ActiveRecord::Migration
  def change
    add_column :reminder_configurations, :use_due_day, :boolean, default: false
  end
end
