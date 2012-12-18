class AddTrackerSelectorToReminderConfigurations < ActiveRecord::Migration
  def self.up
    add_column :reminder_configurations, :tracker_selector, :string
  end

  def self.down
    remove_column :reminder_configurations, :tracker_selector
  end
end
