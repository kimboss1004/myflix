class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.order('position asc')
  end

  def create
    video = Video.find(params[:video_id])
    create_queue_item(video) unless already_queued_video?(video)
    redirect_to queue_items_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if queue_item_belongs_to_current_user?(queue_item)
      queue_item.destroy 
      current_user.normalize_queue_item_positions
    end
    redirect_to queue_items_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      redirect_to queue_items_path
      flash[:danger] = "Invalid position number"
      return
    end
    redirect_to queue_items_path
  end


  private

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data| 
        queue_item = QueueItem.find(queue_item_data['id'])
        queue_item.update_attributes!(position: queue_item_data['position'], rating: queue_item_data['rating']) if queue_item.user == current_user
      end      
    end    
  end

  def create_queue_item(video) 
    @queue_item = QueueItem.create(video: video, user: current_user, position: new_queue_item_position)
  end 

  def already_queued_video?(video)
    current_user.queue_items.map{ |q| q.video }.include?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def queue_item_belongs_to_current_user?(queue_item)
    current_user.queue_items.include?(queue_item)
  end

end