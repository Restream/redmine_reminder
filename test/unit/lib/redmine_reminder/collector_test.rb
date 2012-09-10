require File.expand_path('../../../../test_helper', __FILE__)

class RedmineReminder::CollectorTest < ActiveSupport::TestCase

  fixtures :projects, :users, :members, :member_roles, :roles,
           :groups_users,
           :trackers, :projects_trackers,
           :issue_statuses, :issue_categories, :workflows,
           :enumerations

  def setup
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

    @reminders = RedmineReminder::Collector.collect_reminders()
  end

  def test_reminders_collected
    assert @reminders
  end

  def test_collect_author_issues
    reminders_by_author = @reminders.select { |r| r.user == @author }
    assert_equal 1, reminders_by_author.size
    reminder = reminders_by_author[0]
    assert_equal 1, reminder[:author].size
    assert_equal @issue_soon, reminder[:author][0]
  end

  def test_collect_assigned_to_issues
    reminders_by_assigned_to = @reminders.select { |r| r.user == @assigned_to }
    assert_equal 1, reminders_by_assigned_to.size
    reminder = reminders_by_assigned_to[0]
    assert_equal 1, reminder[:assigned_to].size
    assert_equal @issue_soon, reminder[:assigned_to][0]
  end

  def test_collect_watcher_issues
    reminders_by_wather = @reminders.select { |r| r.user == @watcher }
    assert_equal 1, reminders_by_wather.size
    reminder = reminders_by_wather[0]
    assert_equal 1, reminder[:watcher].size
    assert_equal @issue_soon, reminder[:watcher][0]
  end

  def test_collect_author_as_watcher_issues
    reminders_by_wather = @reminders.select { |r| r.user == @author }
    assert_equal 1, reminders_by_wather.size
    reminder = reminders_by_wather[0]
    assert_equal 1, reminder[:watcher].size
    assert_equal @issue_soon, reminder[:watcher][0]
  end
end
