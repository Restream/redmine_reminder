require 'redmine'

Redmine::Plugin.register :redmine_reminder do
  name 'Advanced reminder'
  author 'Milan Stastny of ALVILA SYSTEMS & Restream'
  description 'E-mail notification of issues due date you are involved in (Assignee, Author, Watcher)'
  version '0.2.1'
  url 'https://github.com/Restream/redmine_reminder'
  author_url 'http://www.alvila.com'

  menu :admin_menu,
    :reminder_options,
    { controller: 'reminder_configuration', action: 'edit' },
    html: { class: 'reminder_options_label' }
end

require_dependency 'redmine_reminder/hooks'
