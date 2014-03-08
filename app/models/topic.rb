class Topic < ActiveRecord::Base
  belongs_to :user
  
  has_many :topic_user_supports
  
  has_many :comments
  
  validates :user_id, presence: true
  # ensure that title is present and at least 10 chars long
  validates :question, length: { minimum: 10 }, presence: true
end
