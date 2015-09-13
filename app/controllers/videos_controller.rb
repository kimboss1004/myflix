class VideosController < ApplicationController

  def home
    
  end

  def show
    @video = Video.find(params[:id])
  end

end