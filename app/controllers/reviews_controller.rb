class ReviewsController < ApplicationController
  before_action :require_user
  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      flash[:success] = "Review has been submitted."
      redirect_to video_path(@video)
    else
      render 'videos/show'
    end
  end


  private

  def review_params
    params.require(:review).permit(:description, :rating)
  end

end