class VideosController < ApplicationController
  before_action :require_user, except: [:root]
  def root
    redirect_to categories_path if logged_in?
  end
  
  def show
    @video = Video.find(params[:id])
    @review = Review.new
  end

  def search
    @results = Video.search_video_title(params[:search])
  end

end