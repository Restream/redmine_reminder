class ReminderConfiguration < ActiveRecord::Base
  unloadable

  ALL = 'all'
  ALL_OPENED = 'all_opened'
  EXPLICIT = 'explicit'

  ISSUE_STATUS_VARIANTS = [ALL_OPENED, EXPLICIT]
  PROJECT_VARIANTS = [ALL, EXPLICIT]

  validates_presence_of :days
  validates_inclusion_of :issue_status_selector, :in => ISSUE_STATUS_VARIANTS
  validates_presence_of :issue_status_selector
  validates_inclusion_of :project_selector, :in => PROJECT_VARIANTS
  validates_presence_of :project_selector

  has_many :reminder_issue_statuses
  has_many :issue_statuses, :through => :reminder_issue_statuses
  has_many :reminder_projects
  has_many :projects, :through => :reminder_projects

  accepts_nested_attributes_for :issue_statuses, :projects

  before_validation_on_create :set_default_values

  class << self
    def instance
      first || create!
    end
  end

  def options_hash
    {
      :days => days,
      :issue_status_selector => issue_status_selector,
      :issue_status_ids => issue_status_ids,
      :project_selector => project_selector,
      :project_ids => project_ids,
      :send_to_author => send_to_author,
      :send_to_assigned_to => send_to_assigned_to,
      :send_to_watcher => send_to_watcher
    }
  end

  private

  def set_default_values
    self.days ||= 7
    self.issue_status_selector ||= ALL_OPENED
    self.project_selector ||= ALL
    self.send_to_author = true if self.send_to_author.nil?
    self.send_to_assigned_to = true if self.send_to_assigned_to.nil?
    self.send_to_watcher = true if self.send_to_watcher.nil?
  end
end
