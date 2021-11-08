class ParticipantMailer < ApplicationMailer
  def new_task_email
    @user = params[:user]
    @task = params[:task]
    mail to: @user.email, subject: 'New task assigned to you!'
  end
end
