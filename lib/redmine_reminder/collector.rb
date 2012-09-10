class RedmineReminder::Collector

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

    #def reminders_all_old(options = {})
    #  days = options[:days] || 7
    #  project = options[:project] ? Project.find(options[:project]) : nil
    #  tracker = options[:tracker] ? Tracker.find(options[:tracker]) : nil
    #
    #  over_due = Array.new
    #  issues_by_assignee = issues_due_in_days_with_assigned_to(
    #      days, :project => project, :tracker => tracker).group_by(&:assigned_to)
    #  issues_by_assignee.each do |assignee, issues|
    #    found = 0
    #    over_due.each do |person|
    #      if person[0].mail == assignee.mail && person[1] == "assignee"
    #        person << issues
    #        found = 1
    #      end
    #    end
    #    if found == 0
    #      over_due << [assignee, "assignee", issues]
    #    end
    #  end
    #
    #  issues_by = issues_due_in_days(days, :project => project, :tracker => tracker)
    #  issues_by.group_by(&:author).each do |author, issues|
    #    found = 0
    #    over_due.each do |person|
    #      if person[0].mail == author.mail && person[1] == "author"
    #        person << issues
    #        found = 1
    #      end
    #    end
    #    if found == 0 then
    #      over_due << [author, "author", issues]
    #    end
    #  end
    #
    #  issues_by.group_by(&:watchers).each do |watchers, issues|
    #    found_watchers = Array.new
    #    over_due.each do |person|
    #      watchers.each do |watcher|
    #        if person[0].mail == watcher.user.mail && person[1] == "watcher"
    #          found_watchers << watcher
    #          person[2] += issues
    #        end
    #      end
    #    end
    #    watchers = watchers - found_watchers
    #    watchers.each do |watcher|
    #      over_due << [watcher.user, "watcher", issues]
    #    end
    #  end
    #  if over_due.size >= 2
    #    over_due.sort! { |x, y| x[0].mail + x[1] <=> y[0].mail + y[1] }
    #  end
    #  previous_user = over_due.empty? ? nil : over_due.first[0]
    #  watched_tasks = Array.new
    #  auth_tasks = Array.new
    #  assigned_tasks = Array.new
    #  sent_issues = Array.new
    #  over_due.each do |user, type, issues|
    #    sent_issues.each do |issue|
    #      issues-=[issue]
    #    end
    #    if previous_user == user then
    #      case type
    #        when "assignee"
    #          assigned_tasks += issues
    #          sent_issues += issues
    #        when "author"
    #          auth_tasks += issues
    #          sent_issues += issues
    #        when "watcher" then
    #          watched_tasks += issues
    #          sent_issues += issues
    #      end
    #    else
    #      if assigned_tasks.length > 1
    #        assigned_tasks.sort! { |a, b| b.due_date <=> a.due_date }
    #      end
    #      if auth_tasks.length > 1
    #        auth_tasks.sort! { |a, b| b.due_date <=> a.due_date }
    #      end
    #      if watched_tasks.length > 1 then
    #        watched_tasks.sort! { |a, b| b.due_date <=> a.due_date }
    #      end
    #      deliver_reminder_all(previous_user, assigned_tasks, auth_tasks, watched_tasks, days) unless previous_user.nil?
    #      watched_tasks.clear
    #      auth_tasks.clear
    #      assigned_tasks.clear
    #      sent_issues.clear
    #      previous_user = user
    #      case type
    #        when "assignee"
    #          assigned_tasks += issues
    #          sent_issues += issues
    #        when "author"
    #          auth_tasks += issues
    #          sent_issues += issues
    #        when "watcher" then
    #          watched_tasks += issues
    #          sent_issues += issues
    #      end
    #    end
    #  end
    #  deliver_reminder_all(previous_user, assigned_tasks, auth_tasks, watched_tasks, days) unless previous_user.nil?
    #end
    #
    #private
    #
    ## Get issues due in X days with assigned_to
    #def issues_due_in_days_with_assigned_to(*args)
    #  days = args[0]
    #  options = args.extract_options!
    #  project = options[:project]
    #  tracker = options[:tracker]
    #  s = ARCondition.new ["#{Issue.table_name}.due_date <= ?",
    #                       days.day.from_now.to_date]
    #  s << issues_statuses
    #  s << "#{Issue.table_name}.assigned_to_id IS NOT NULL"
    #  s << "#{Project.table_name}.status = #{Project::STATUS_ACTIVE}"
    #  s << "#{Issue.table_name}.project_id = #{project.id}" if project
    #  s << "#{Issue.table_name}.tracker_id = #{tracker.id}" if tracker
    #  Issue.find(:all, :include => [:status, :assigned_to, :project, :tracker],
    #             :conditions => s.conditions)
    #end
    #
    ## Get issues due in X days
    #def issues_due_in_days_old(*args)
    #  days = args[0]
    #  options = args.extract_options!
    #  project = options[:project]
    #  tracker = options[:tracker]
    #  s = ARCondition.new ["#{Issue.table_name}.due_date <= ?",
    #                       days.day.from_now.to_date]
    #  s << issues_statuses
    #  s << "#{Project.table_name}.status = #{Project::STATUS_ACTIVE}"
    #  s << "#{Issue.table_name}.project_id = #{project.id}" if project
    #  s << "#{Issue.table_name}.tracker_id = #{tracker.id}" if tracker
    #  Issue.find(:all, :include => [:status, :author, :project, :watchers, :tracker],
    #             :conditions => s.conditions)
    #end
  end

end
