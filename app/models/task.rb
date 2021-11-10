# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  due_date    :date
#  category_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint           not null
#  code        :string
#
class Task < ApplicationRecord
  belongs_to :category
  belongs_to :owner, class_name: 'User'
  has_many :participanting_users, class_name: 'Participant'
  has_many :participants, through: :participanting_users, source: :user
  has_many :notes

  validates :participanting_users, presence: true
  validates :name, :description, presence: true
  validates :name, uniqueness: { case_insensitive: false }
  validate :due_date_cannot_be_in_the_past

  before_create :generate_code
  after_create :send_email_to_participants

  accepts_nested_attributes_for :participanting_users, allow_destroy: true

  def due_date_cannot_be_in_the_past
    return if due_date.blank?
    return if due_date >= Date.today
    errors.add(:due_date, I18n.t('tasks.errors.cannot_be_in_the_past'))
  end

  def generate_code
    self.code = "#{owner_id}_#{Time.now.to_i.to_s(36)}_#{SecureRandom.hex(8)}"
  end

  def send_email_to_participants
    participants.each do |participant|
      # ParticipantMailer.with(task: self, user: participant).new_task_email.deliver!
    end
  end

end
