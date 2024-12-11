class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@example.com" # TODO: update when setting up production emails
  layout "mailer"
end
