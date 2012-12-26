class ReminderConfiguration < ActiveRecord::Base
  unloadable

  ALL = 'all'
  ALL_OPENED = 'all_opened'
  EXPLICIT = 'explicit'

  ISSUE_STATUS_VARIANTS = [ALL_OPENED, EXPLICIT]
  PROJECT_VARIANTS = [ALL, EXPLICIT]
  TRACKER_VARIANTS = [ALL, EXPLICIT]

  validates :days, :presence => true

  validates :issue_status_selector,
            :presence => true,
            :inclusion => { :in => ISSUE_STATUS_VARIANTS }

  validates :project_selector,
            :presence => true,
            :inclusion => { :in => PROJECT_VARIANTS }

  validates :tracker_selector,
            :presence => true,
            :inclusion => { :in => TRACKER_VARIANTS }

  has_many :reminder_issue_statuses
  has_many :issue_statuses, :through => :reminder_issue_statuses
  has_many :reminder_projects
  has_many :projects, :through => :reminder_projects
  has_many :reminder_trackers
  has_many :trackers, :through => :reminder_trackers

  accepts_nested_attributes_for :issue_statuses, :projects, :trackers

  class << self
    def instance
      first || create!
    end
  end

  after_initialize do
    set_default_values if new_record?
  end

  private

  def set_default_values
    self.days ||= 7
    self.issue_status_selector ||= ALL_OPENED
    self.project_selector ||= ALL
    self.tracker_selector ||= ALL
    self.send_to_author = true if self.send_to_author.nil?
    self.send_to_assigned_to = true if self.send_to_assigned_to.nil?
    self.send_to_watcher = true if self.send_to_watcher.nil?
    self.send_to_custom_user ||= false
    true
  end
end
