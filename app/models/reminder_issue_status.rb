class ReminderIssueStatus < ActiveRecord::Base
  unloadable
  belongs_to :reminder_configuration
  belongs_to :issue_status, :dependent => :destroy
end
