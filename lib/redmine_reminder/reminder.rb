class RedmineReminder::Reminder
  attr_reader :user, :issues

  def initialize(user)
    @user = user
    @issues = {}
  end

  def [](key)
    @issues[key] ||= []
    @issues[key]
  end

  def keys
    @issues.keys
  end

  def uniq!
    @issues.keys.each do |key|
      @issues[key].uniq!
    end
  end
end
