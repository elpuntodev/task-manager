class Tasks::TriggerEvent
  def call(task, event)
    task.send "#{event}!" # Meta programming. If event is "start" then task.start!
    # security policies
    # access policies
    # connection to another services
    [true, 'Successfully']
  rescue => e
    Rails.logger.error "Error sending email: #{e.message}"
    [false, 'Failure'] 
  end
end