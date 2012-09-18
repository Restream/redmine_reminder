# Advanced Redmine Notifications

E-mail notification of issues due date you are involved in (Assignee, Author, Watcher, Custom field)

## Install

Follow the plugin installation procedure at http://www.redmine.org/wiki/redmine/Plugins.

## Usage

The plugin runs as a rake task so you have to set it up in cron or task sheduler

1 0 * * *       root    cd /opt/redmine && rake redmine:send_reminders_all RAILS_ENV=production

You can setup options in administration menu.

![Reminder options in administration menu](https://github.com/Undev/redmine_reminder/feature/1.4-compatibility/screenshot.png)
