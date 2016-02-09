class RelationshipsController < ApplicationController
  before_action :require_user

  def create
    @star = User.find(params[:id])

    if @star && @star != current_user && !current_user.stars.include?(@star)
      @star.followers << current_user
      flash[:success] = "You are following #{@star.full_name}"
      redirect_to people_user_path(current_user)
      return
    else
      flash[:error] = "There was an error or you are already following user"
      redirect_to user_path(current_user)
      return
    end
  end


  def destroy 
    @star = User.find(params[:id])
    if @star
      @relationship = Relationship.where(follower_id: current_user, star_id: @star).first
      if @relationship
        @relationship.destroy
        flash[:success] = "You have unfollowed #{@star.full_name}"
        redirect_to people_user_path(current_user)
        return
      else
        flash[:error] = "Error"
        redirect_to people_user_path(current_user)
        return
      end
    end
  end



end