require File.dirname(__FILE__) + '/../test_helper'

class ReminderConfigurationsTest < ActiveSupport::TestCase
  fixtures :reminder_configurations

  def test_get_instance
    conf = ReminderConfiguration.instance
    assert conf
  end
end
