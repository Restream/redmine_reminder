require File.expand_path('../../test_helper', __FILE__)

class ReminderAllMailerTest < ActiveSupport::TestCase

  fixtures :projects, :users, :members, :member_roles, :roles,
           :groups_users,
           :trackers, :projects_trackers,
           :issue_statuses, :issue_categories, :workflows,
           :enumerations

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.deliveries.clear
    Setting.host_name = 'mydomain.foo'
    Setting.protocol = 'http'
    Setting.default_language = 'en'

    @project = Project.find(1)
    @author = User.find(2)
    @assigned_to = User.find(3)
    @watcher = User.find(4)
    options = {
        :author => @author,
        :assigned_to => @assigned_to
    }
    @issue_soon = Issue.generate_for_project! @project,
                                              options.merge(:due_date => 2.days.since)
    @issue_soon.add_watcher @watcher
    @issue_soon.add_watcher @author
    @issue_future = Issue.generate_for_project! @project,
                                                options.merge(:due_date => 8.days.since)
    @issue_future.add_watcher @watcher
    @issue_future.add_watcher @author

    @options = ReminderConfiguration.instance
    collector = RedmineReminder::Collector.new(@options)
    @reminders = collector.collect_reminders

    @reminder = @reminders.first

  end

  def last_email
    mail = ActionMailer::Base.deliveries.last
    assert_not_nil mail
    mail
  end

  def test_html_reminder_all
    Setting.plain_text_mail = '0'
    assert ReminderAllMailer.deliver_reminder_all(
               @reminder.user,
               @reminder[:assigned_to],
               @reminder[:author],
               @reminder[:watcher],
               @reminder[:custom_user],
               @options.days
           )

    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = last_email
    assert mail.bcc.include?(@reminder.user.mail)
    assert_mail_body_match @issue_soon.subject, mail
  end

  def test_text_reminder_all
    Setting.plain_text_mail = 1
    assert ReminderAllMailer.deliver_reminder_all(
               @reminder.user,
               @reminder[:assigned_to],
               @reminder[:author],
               @reminder[:watcher],
               @reminder[:custom_user],
               @options.days
           )

    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = last_email
    assert mail.bcc.include?(@reminder.user.mail)
    assert_mail_body_match @issue_soon.subject, mail
  end
end
