require 'redmine'

Redmine::Plugin.register :redmine_reminder do
  name 'Advanced reminder'
  author 'Milan Stastny of ALVILA SYSTEMS'
  description 'E-mail notification of issues due date you are involved in (Assignee, Author, Watcher)'
  version '0.0.2'
  url 'https://github.com/Undev/redmine_cut_tag'
  author_url 'http://www.alvila.com'
end

