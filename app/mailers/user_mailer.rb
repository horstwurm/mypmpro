class UserMailer < ApplicationMailer
  default from: 'postmaster@mg.mytgcloud.com'

  add_template_helper(EmailHelper)
 
  def welcome_email(user)
    @url = $appurl
    @user = user
    mail(to: user.email, subject: (I18n.t :welcometo))
    #mail(to: "wurmhorst63@gmail.com", subject: 'Welcome to My Awesome Site')
  end
  
  def send_email(user_to, user_from, header, text)
    @url = $appurl
    @user_to = user_to
    @user_from = user_from
    @text = text
    mail(from: user_from.email, to: user_to.email, subject: header)
    #mail(to: "wurmhorst63@gmail.com", subject: 'Welcome to My Awesome Site')
  end
  
  def user_access_info(user, header, text, mobject)
    @url = $appurl
    @user = user
    @text = text
    @mobject = mobject
    @header = header
    mail(to: user.email, subject: header)
    #mail(to: "wurmhorst63@gmail.com", subject: 'Welcome to My Awesome Site')
  end
  
end
