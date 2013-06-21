require File.dirname(__FILE__) + '/../test_helper'

class ReminderConfigurationsTest < ActiveSupport::TestCase

  def test_get_instance
    conf = ReminderConfiguration.instance
    assert conf
  end
end
