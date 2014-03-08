class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]

  # GET /topics
  # GET /topics.json
  def index
    @topics = current_user.topics
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @vote =""
    @upcount = @topic.topic_user_supports.where(:support => true).count
    @downcount = @topic.topic_user_supports.where(:support => false).count
    @all_users = @topic.topic_user_supports.select(:user_id).where(:support => true).to_a
    @voters = Array.new
    @all_users.each do |x|
      @voters << x.user_id
    end
    
    @support_comments = @topic.comments.where(:user_id => @voters)
    @against_comments = @topic.comments.where.not(:user_id => @voters)
    
    if !current_user.nil?
      @vote = @topic.topic_user_supports.where(:user_id => current_user.id).first
    end
  end
  
  def vote
    @topic = Topic.find(params[:id])
    @check = @topic.topic_user_supports.where(:user_id=>current_user.id)
    if @check.blank?
      @vote = TopicUserSupport.new(:user_id => current_user.id, :topic_id=>@topic.id, :support => params[:support])
      if params[:support]== "true"
        @cast = "supporting"
      else
        @cast = "against"
      end
        
      respond_to do |format|
        if @vote.save
          if !current_user.uid.blank?
            @fb_user = FbGraph::User.me(session[:fb_access_token].strip)
            @fb_user.feed!(
              :message => "I'm "+@cast+" a topic! Check it out",
              :link => "ec2-54-80-154-0.compute-1.amazonaws.com/topics/"+@topic.id.to_s
            )
          end
          format.html { redirect_to @topic, notice: 'Succesfully voted.' }
          format.json { render action: 'show', status: :created, location: @topic }
        else
          format.html { redirect_to action: 'show' }
          format.json { render json: @vote.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to action: 'show'
    end
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @topic }
      else
        format.html { render action: 'new' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:question, :enable)
    end
end
