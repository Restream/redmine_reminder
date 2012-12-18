class CreateReminderIssueStatuses < ActiveRecord::Migration
  def self.up
    create_table :reminder_issue_statuses do |t|
      t.column :reminder_configuration_id, :integer
      t.column :issue_status_id, :integer
    end
  end

  def self.down
    drop_table :reminder_issue_statuses
  end
end
