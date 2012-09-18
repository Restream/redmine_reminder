class ReminderTracker < ActiveRecord::Base
  unloadable
  belongs_to :reminder_configuration
  belongs_to :tracker, :dependent => :destroy
end
