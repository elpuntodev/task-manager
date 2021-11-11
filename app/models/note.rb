class Note 
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :task

  field :body, type: String

  validates :body, presence: true
end
