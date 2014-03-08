class HomeController < ApplicationController
  def index
    @topics = Topic.all
  end
  
  def autocomplete_tag_name
    tags = User.select([:email]).where("name LIKE ?", "%#{params[:name]}%")
        result = tags.collect do |t|
          { value: t.name }
        end
        render json: result
  end
end
