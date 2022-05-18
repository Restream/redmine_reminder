class AddTrackerSelectorToReminderConfigurations < ActiveRecord::Migration[5.1]
  def self.up
    unless column_exists? :reminder_configurations, :tracker_selector
      add_column :reminder_configurations, :tracker_selector, :string
    end
  end

  def self.down
    if column_exists? :reminder_configurations, :tracker_selector
      remove_column :reminder_configurations, :tracker_selector
    end
  end
end
