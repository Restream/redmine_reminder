class ReminderProject < ActiveRecord::Base
  unloadable
  belongs_to :reminder_configuration
  belongs_to :project, dependent: :destroy
end
