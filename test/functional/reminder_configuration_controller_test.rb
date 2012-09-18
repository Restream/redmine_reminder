require File.dirname(__FILE__) + '/../test_helper'

class ReminderConfigurationControllerTest < ActionController::TestCase
  fixtures :projects, :users, :issue_statuses

  def setup
    @request    = ActionController::TestRequest.new
    @request.session[:user_id] = 1 # admin
  end

  def test_index
    get :edit
    assert_response :success
    assert_template 'edit'
  end

  def test_get_edit
    get :edit
    assert_response :success
  end

  def test_update_configuration
    attrs = {
      :days => 20,
      :issue_status_selector => 'explicit',
      :project_selector => 'explicit',
      :send_to_author => false,
      :send_to_assigned_to => false,
      :send_to_watcher => false,
      :send_to_custom_user => false
    }
    put :update, reminder_configuration: attrs
    assert_response :redirect

    conf = ReminderConfiguration.instance
    assert_equal attrs[:days], conf.days
    assert_equal attrs[:issue_status_selector], conf.issue_status_selector
    assert_equal attrs[:project_selector], conf.project_selector
    assert_equal attrs[:send_to_author], conf.send_to_author
    assert_equal attrs[:send_to_assigned_to], conf.send_to_assigned_to
    assert_equal attrs[:send_to_watcher], conf.send_to_watcher
    assert_equal attrs[:send_to_custom_user], conf.send_to_custom_user
  end

end
