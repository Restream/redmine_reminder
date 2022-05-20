class CreateReminderTrackers < ActiveRecord::Migration[5.1]
  def self.up
    create_table :reminder_trackers do |t|
      t.column :reminder_configuration_id, :integer
      t.column :tracker_id, :integer
    end unless table_exists? :reminder_trackers
  end

  def self.down
    drop_table :reminder_trackers if table_exists? :reminder_trackers
  end
end
