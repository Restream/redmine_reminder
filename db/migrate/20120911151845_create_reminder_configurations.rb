class CreateReminderConfigurations < ActiveRecord::Migration
  def self.up
    create_table :reminder_configurations, :force => true do |t|
      t.column :days, :integer
      t.column :issue_status_selector, :string
      t.column :project_selector, :string
      t.column :send_to_author, :boolean
      t.column :send_to_assigned_to, :boolean
      t.column :send_to_watcher, :boolean
      t.column :send_to_custom_user, :boolean

      t.timestamps
    end unless table_exists? :reminder_configurations
  end

  def self.down
    drop_table :reminder_configurations if table_exists? :reminder_configurations
  end
end
