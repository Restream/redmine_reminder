require File.dirname(__FILE__) + '/../test_helper'

class ReminderConfigurationsTest < ActiveSupport::TestCase
  fixtures :reminder_configurations

  def test_get_instance
    conf = ReminderConfiguration.instance
    assert conf
  end

  def test_get_options_hash
    hash = ReminderConfiguration.instance.options_hash
    assert hash
  end
end
