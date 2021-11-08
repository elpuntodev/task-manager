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
#
class Task < ApplicationRecord
  belongs_to :category
  belongs_to :owner, class_name: 'User'
  has_many :participanting_users, class_name: 'Participant'
  has_many :participants, through: :participanting_users, source: :user

  validates :participanting_users, presence: true
  validates :name, :description, presence: true
  validates :name, uniqueness: { case_insensitive: false }
  validate :due_date_cannot_be_in_the_past

  accepts_nested_attributes_for :participanting_users, allow_destroy: true

  def due_date_cannot_be_in_the_past
    return if due_date.blank?
    return if due_date >= Date.today
    errors.add(:due_date, I18n.t('tasks.errors.cannot_be_in_the_past'))
  end
end
