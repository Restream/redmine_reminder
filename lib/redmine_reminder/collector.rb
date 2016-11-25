class RedmineReminder::Collector
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def collect_reminders
    reminders = {}

    issues = issues_due_in_days
    issues.each do |issue|

      if options.send_to_author?
        reminders[issue.author] ||=
          RedmineReminder::Reminder.new(issue.author)
        reminders[issue.author][:author] << issue
      end

      if options.send_to_assigned_to? && issue.assigned_to
        reminders[issue.assigned_to] ||=
          RedmineReminder::Reminder.new(issue.assigned_to)
        reminders[issue.assigned_to][:assigned_to] << issue
      end

      if options.send_to_watcher?
        issue.watchers.each do |watcher|
          reminders[watcher.user] ||=
            RedmineReminder::Reminder.new(watcher.user)
          reminders[watcher.user][:watcher] << issue
        end
      end

      if options.send_to_custom_user?
        issue_custom_users(issue).each do |custom_user|
          reminders[custom_user] ||=
            RedmineReminder::Reminder.new(custom_user)
          reminders[custom_user][:custom_user] << issue
        end
      end
    end
    reminders.values.map &:uniq!
    reminders.values || []
  end

  private

  # Get issues due in X days
  def issues_due_in_days
    due_date      = options.days.day.from_now.to_date
    sql_condition = ARCondition.new ["#{Issue.table_name}.due_date <= ?", due_date]
    sql_condition << issue_statuses
    sql_condition << projects
    sql_condition << trackers
    Issue.joins(:status, :assigned_to, :author, :project, :watchers, :tracker).
      where(sql_condition.conditions).
      order("#{Issue.table_name}.due_date, #{Project.table_name}.name")
  end

  def issue_statuses
    case options.issue_status_selector
      when 'explicit'
        ["#{IssueStatus.table_name}.id in (?)", options.issue_status_ids]
      when 'all_opened'
        ["#{IssueStatus.table_name}.is_closed = ?", false]
      else
        raise "unknown issue_status_selector value: #{options.issue_status_selector}"
    end
  end

  def projects
    case options.project_selector
      when 'explicit'
        ["#{Project.table_name}.id in (?)", options.project_ids]
      when 'all'
        ["#{Project.table_name}.status = ?", Project::STATUS_ACTIVE]
      else
        raise "unknown project_selector value: #{options.project_selector}"
    end
  end

  def trackers
    case options.tracker_selector
      when 'explicit'
        ["#{Tracker.table_name}.id in (?)", options.tracker_ids]
      when 'all'
        '1=1'
      else
        raise "unknown tracker_selector value: #{options.tracker_selector}"
    end
  end

  def issue_custom_users(issue)
    custom_user_values = issue.custom_field_values.select do |v|
      v.custom_field.field_format == 'user'
    end
    custom_user_ids    = custom_user_values.map(&:value).flatten
    custom_user_ids.reject! { |id| id.blank? }
    User.find(custom_user_ids)
  end

end
