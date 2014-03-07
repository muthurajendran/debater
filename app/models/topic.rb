class Topic < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  # ensure that title is present and at least 10 chars long
  validates :question, length: { minimum: 10 }, presence: true
end
