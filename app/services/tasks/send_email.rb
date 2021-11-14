class Tasks::SendEmail
  def call(task)
    task.participants.each do |participant|
      ParticipantMailer.with(user: participant, task: task).new_task_email.deliver!
    end
    [true, 'Email sent successfully']
  rescue => e
    Rails.logger.error "Error sending email: #{e.message}"
    [false, 'Fail sending email'] 
  end
end