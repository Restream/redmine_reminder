class ReminderConfiguration < ActiveRecord::Base
  unloadable

  ALL = 'all'
  ALL_OPENED = 'all_opened'
  EXPLICIT = 'explicit'

  ISSUE_STATUS_VARIANTS = [ALL_OPENED, EXPLICIT]
  PROJECT_VARIANTS = [ALL, EXPLICIT]
  TRACKER_VARIANTS = [ALL, EXPLICIT]

  validates_presence_of :days
  validates_inclusion_of :issue_status_selector, :in => ISSUE_STATUS_VARIANTS
  validates_presence_of :issue_status_selector
  validates_inclusion_of :project_selector, :in => PROJECT_VARIANTS
  validates_presence_of :project_selector
  validates_inclusion_of :tracker_selector, :in => TRACKER_VARIANTS
  validates_presence_of :tracker_selector

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

  def after_initialize
    set_default_values if new_record?
  end

  def options_hash
    {
      :days => days,
      :issue_status_selector => issue_status_selector,
      :issue_status_ids => issue_status_ids,
      :project_selector => project_selector,
      :project_ids => project_ids,
      :tracker_selector => tracker_selector,
      :tracker_ids => tracker_ids,
      :send_to_author => send_to_author,
      :send_to_assigned_to => send_to_assigned_to,
      :send_to_watcher => send_to_watcher,
      :send_to_custom_user => send_to_custom_user
    }
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
