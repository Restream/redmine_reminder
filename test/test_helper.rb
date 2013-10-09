require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

class ActiveSupport::TestCase
  def mail_body(mail)
    mail.multipart? ? mail.parts.first.body.encoded : mail.body.encoded
  end

  def generate_issue!(project, options)
    issue = project.issues.build(options)
    issue.subject = "subject #{rand(100)}" if issue.subject.blank?
    issue.tracker ||= project.trackers.first
    issue.save!
    issue
  end
end

