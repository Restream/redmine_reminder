class RedmineReminder::Collector
  attr_reader :options

  def initialize(options)
    @options = options
  end

  class << self
    def collect_reminders(options = {})
      reminders = {}
      days = options[:days] || 7
      project = options[:project] ? Project.find(options[:project]) : nil
      tracker = options[:tracker] ? Tracker.find(options[:tracker]) : nil

      issues = issues_due_in_days(days, :project => project, :tracker => tracker)
      issues.each do |issue|

        reminder = (reminders[issue.author] ||=
            RedmineReminder::Reminder.new(issue.author))
        reminder[:author] << issue

        if issue.assigned_to
          reminder = (reminders[issue.assigned_to] ||=
              RedmineReminder::Reminder.new(issue.assigned_to))
          reminder[:assigned_to] << issue
        end

        issue.watchers.each do |watcher|
          reminder = (reminders[watcher.user] ||=
              RedmineReminder::Reminder.new(watcher.user))
          reminder[:watcher] << issue
        end
      end
      reminders.values.map &:uniq!
      reminders.values || []
    end

    private

    # Get issues due in X days
    def issues_due_in_days(*args)
      days = args[0]
      options = args.extract_options!
      project = options[:project]
      tracker = options[:tracker]
      s = ARCondition.new ["#{Issue.table_name}.due_date <= ?",
                           days.day.from_now.to_date]
      s << issue_statuses
      s << "#{Project.table_name}.status = #{Project::STATUS_ACTIVE}"
      s << "#{Issue.table_name}.project_id = #{project.id}" if project
      s << "#{Issue.table_name}.tracker_id = #{tracker.id}" if tracker
      Issue.find(:all, :include => [:status, :assigned_to, :author, :project, :watchers, :tracker],
                 :conditions => s.conditions)
    end

    def issue_statuses
      #TODO: modify issues.is_closed == false to issue set

      ["#{IssueStatus.table_name}.is_closed = ?", false]
    end
  end

end
