class CreateReminderIssueStatuses < ActiveRecord::Migration[5.1]
  def self.up
    create_table :reminder_issue_statuses do |t|
      t.column :reminder_configuration_id, :integer
      t.column :issue_status_id, :integer
    end unless table_exists? :reminder_issue_statuses
  end

  def self.down
    drop_table :reminder_issue_statuses if table_exists? :reminder_issue_statuses
  end
end
