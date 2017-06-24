class ReminderAllMailer < Mailer
  helper :reminder_all

  def reminder_all(user, assigned_issues, auth_issues, watched_issues, custom_user_issues, without_due_day, days)
    recipients          = user.mail
    day_tag             = [l(:mail_reminder_all_day1), l(:mail_reminder_all_day2),
      l(:mail_reminder_all_day2), l(:mail_reminder_all_day2),
      l(:mail_reminder_all_day5)]
    issues_count        = (assigned_issues + auth_issues + watched_issues + custom_user_issues).uniq.size
    plural_subject_term = case issues_count
      when 1 then
        :mail_subject_reminder_all1
      when 2..4 then
        :mail_subject_reminder_all2
      else
        :mail_subject_reminder_all5
    end
    l_day_dag           = day_tag[(days > 4 ? 4 : days - 1)]
    subject             = l(
      plural_subject_term,
      count: issues_count,
      days:  days,
      day:   l_day_dag)
    @assigned_issues    = assigned_issues
    @auth_issues        = auth_issues
    @watched_issues     = watched_issues
    @custom_user_issues = custom_user_issues
    @without_due_day    = without_due_day
    @days               = days
    @issues_url         = url_for(
      controller: 'issues',
      action:     'index',
      set_filter: 1, assigned_to_id: user.id,
      sort_key:   'due_date', sort_order: 'asc')

    mail to: recipients, subject: subject
  end

  def self.deliver_reminder_all_if_any(user, assigned_issues, auth_issues, watched_issues, custom_user_issues, without_due_day, days)
    issues_count = (assigned_issues + auth_issues + watched_issues + custom_user_issues + without_due_day).uniq.size
    reminder_all(user, assigned_issues, auth_issues, watched_issues,
      custom_user_issues, without_due_day, days).deliver if issues_count > 0
  end
end
