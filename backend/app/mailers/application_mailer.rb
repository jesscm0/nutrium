class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@nutrium.com'
  layout 'mailer'

  def notify_email(email, name, nutritionist, date, status)
    @name = name
    @nutritionist = nutritionist
    @date = date
    @status = status
    
    mail(to: email, subject: "[Nutrium] Appointment Status Update")
  end
end