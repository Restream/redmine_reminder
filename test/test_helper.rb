require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

ActiveSupport::TestCase.append_fixture_path File.expand_path('../fixtures', __FILE__)

class ActiveSupport::TestCase
  def mail_body(mail)
    mail.multipart? ? mail.parts.first.body.encoded : mail.body.encoded
  end
end

