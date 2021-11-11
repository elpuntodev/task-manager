class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :due_date, type: Date
  field :code, type: String

  belongs_to :category
  belongs_to :owner, class_name: 'User'
  has_many :participating_users, class_name: 'Participant'
  has_many :notes

  validates :participating_users, presence: true
  validates :name, :description, presence: true
  validates :name, uniqueness: { case_insensitive: false }
  validate :due_date_cannot_be_in_the_past

  before_create :generate_code
  after_create :send_email_to_participants

  accepts_nested_attributes_for :participating_users, allow_destroy: true

  def participants
    participating_users.include(:user).map(&:user)
  end

  def due_date_cannot_be_in_the_past
    return if due_date.blank?
    return if due_date >= Date.today
    errors.add(:due_date, I18n.t('tasks.errors.cannot_be_in_the_past'))
  end

  def generate_code
    self.code = "#{owner_id}_#{Time.now.to_i.to_s(36)}_#{SecureRandom.hex(8)}"
  end

  def send_email_to_participants
    return
    participants.each do |participant|
      ParticipantMailer.with(task: self, user: participant).new_task_email.deliver!
    end
  end

end
