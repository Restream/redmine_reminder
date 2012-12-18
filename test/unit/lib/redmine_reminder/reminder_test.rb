require File.expand_path('../../../../test_helper', __FILE__)

class RedmineReminder::ReminderTest < ActiveSupport::TestCase

  def setup
    @user = :user_stub
    @issue1 = :stub1
    @issue2 = :stub1
    @issue3 = :stub3
    @reminder = RedmineReminder::Reminder.new(@user)
  end

  def test_reminder_allow_add_issues
    @reminder[:author] << :stub1
    @reminder[:assigned_to] << :stub2
    @reminder[:watcher] << :stub3
    assert_equal [:stub1], @reminder[:author]
    assert_equal [:stub2], @reminder[:assigned_to]
    assert_equal [:stub3], @reminder[:watcher]
  end

  def test_reminder_keys
    @reminder[:author] << :stub1
    @reminder[:assigned_to] << :stub2
    @reminder[:watcher] << :stub3
    assert_equal [:author, :assigned_to, :watcher], @reminder.keys
  end

  def test_reminder_uniq
    3.times { @reminder[:author] << :stub1 }
    4.times { @reminder[:assigned_to] << :stub2 }
    5.times { @reminder[:watcher] << :stub3 }
    @reminder.uniq!
    assert_equal [:stub1], @reminder[:author]
    assert_equal [:stub2], @reminder[:assigned_to]
    assert_equal [:stub3], @reminder[:watcher]
  end
end
