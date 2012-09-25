module ReminderAllHelper
  def l_days(days_count)
    day_tag = [
        t(:mail_reminder_all_day1),
        t(:mail_reminder_all_day2),
        t(:mail_reminder_all_day2),
        t(:mail_reminder_all_day2),
        t(:mail_reminder_all_day5)
    ]
    day_tag[days_count > 4 ? 4 : days_count - 1]
  end

  %w(mail_body_reminder_assigned mail_body_reminder_auth mail_body_reminder_watched mail_body_reminder_custom_user).each do |term|
    define_method "l_#{term}" do |count, days, day|
      countable_term = case count
        when 1
          "#{term}1"
        when 2..4
          "#{term}2"
        else
          "#{term}5"
      end
      t(countable_term, :count => count, :days => days, :day => l_days(days))
    end
  end
end
