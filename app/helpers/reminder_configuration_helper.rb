module ReminderConfigurationHelper
  def issue_status_selector_for_select
    ReminderConfiguration::ISSUE_STATUS_VARIANTS.map do |var|
      [l(var, :scope => [:redmine_reminder, :issue_statuses]), var]
    end
  end

  def issue_statuses_for_select(configuration)
    options_from_collection_for_select IssueStatus.all, 'id', 'name',
                                       configuration.issue_status_ids
  end

  def project_selector_for_select
    ReminderConfiguration::PROJECT_VARIANTS.map do |var|
      [l(var, :scope => [:redmine_reminder, :projects]), var]
    end
  end

  def projects_for_select(configuration)
    options_from_collection_for_select Project.all, 'id', 'name',
                                       configuration.project_ids
  end

  def tracker_selector_for_select
    ReminderConfiguration::TRACKER_VARIANTS.map do |var|
      [l(var, :scope => [:redmine_reminder, :trackers]), var]
    end
  end

  def trackers_for_select(configuration)
    options_from_collection_for_select Tracker.all, 'id', 'name',
                                       configuration.tracker_ids
  end
end
