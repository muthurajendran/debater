class CommentsController < ApplicationController
  def create
     @topic = Topic.find(params[:topic_id])
     @comment = @topic.comments.new(params[:comment].permit(:user_id, :body))
     @comment.user_id = current_user.id
     @comment.save
     redirect_to topic_path(@topic)
     
   end
end
