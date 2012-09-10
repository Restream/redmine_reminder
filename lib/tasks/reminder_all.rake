# redMine - project management software
# Copyright (C) 2008  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path(File.dirname(__FILE__) + "/../../../../../config/environment")
require "mailer"
require File.expand_path(File.dirname(__FILE__) + "/../../app/models/reminder_all_mailer")

desc <<-END_DESC
Send reminders about issues due in the next days.

Available options:
  * days     => number of days to remind about (defaults to 7)
  * tracker  => id of tracker (defaults to all trackers)
  * project  => id or identifier of project (defaults to all projects)

Example:
  rake redmine:send_reminders_all days=7 RAILS_ENV="production"
END_DESC

namespace :redmine do
  task :send_reminders_all => :environment do
    options = {}
    options[:days] = ENV['days'].present? ? ENV['days'].to_i : 7
    options[:project] = ENV['project'] if ENV['project']
    options[:tracker] = ENV['tracker'].to_i if ENV['tracker']

    RedmineReminder::Collector.collect_reminders(options).each do |r|
      ReminderAllMailer.with_synched_deliveries do
        ReminderAllMailer.deliver_reminder_all(r.user,
           r[:assigned_to], r[:author], r[:watcher], options[:days])
      end
    end
  end
end

