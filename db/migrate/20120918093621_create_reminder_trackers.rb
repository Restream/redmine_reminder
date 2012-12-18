class CreateReminderTrackers < ActiveRecord::Migration
  def self.up
    create_table :reminder_trackers do |t|
      t.column :reminder_configuration_id, :integer
      t.column :tracker_id, :integer
    end
  end

  def self.down
    drop_table :reminder_trackers
  end
end
