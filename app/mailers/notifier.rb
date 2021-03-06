class Notifier < ActionMailer::Base
  default from: Devise.mailer_sender
  
  # call Notifier.notify_nurse(nurse_obj).deliver
  def notify_nurse(nurse)
    @nurse = nurse
    subject = "It is now your turn to schedule your vacation"
    mail(:to => nurse.email, :subject => subject)
  end
  
  def notify_admin(admin, nurse)
    @admin = admin
    subject = "#{nurse.name} has finished scheduling his or her vacation"
    mail(:to => @admin.email, :subject => subject)
  end
end
