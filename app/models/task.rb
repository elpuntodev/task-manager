class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  field :name, type: String
  field :description, type: String
  field :due_date, type: Date
  field :code, type: String
  field :status, type: String
  field :transitions, type: Array, default: []

  belongs_to :category
  belongs_to :owner, class_name: 'User'
  has_many :participating_users, class_name: 'Participant'
  # has_many :participants, through: :participating_users, source: :user # Using ActiveRecord
  has_many :notes

  validates :participating_users, presence: true
  validates :name, :description, presence: true
  validates :name, uniqueness: { case_insensitive: false }
  validate :due_date_cannot_be_in_the_past

  before_create :generate_code
  after_create :send_email_to_participants

  accepts_nested_attributes_for :participating_users, allow_destroy: true

  
  aasm column: :status do
    state :pending, initial: true
    state :in_progress, :finished
    
    after_all_transitions :audit_status_change

    event :start do
      transitions from: :pending, to: :in_progress
    end

    event :finish do
      transitions from: :in_progress, to: :finished
    end
  end

  def audit_status_change
    Rails.logger.info "changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
    set transitions: transitions.push({
      from_state: aasm.from_state,
      to_state: aasm.to_state,
      current_event: aasm.current_event,
      timestamps: Time.zone.now
    })
  end

  def participants
    participating_users.includes(:user).map(&:user)
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
    Tasks::SendEmailJob.perform_async(id.to_s)
  end

end
