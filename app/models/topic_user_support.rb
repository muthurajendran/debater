class TopicUserSupport < ActiveRecord::Base
  belongs_to :users
  belongs_to :topic
end
