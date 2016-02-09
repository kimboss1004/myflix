class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  belongs_to :category

  validates_numericality_of :position, {only_integer: true}


  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating) 
    else
      Review.new(user: user, video: video, rating: new_rating).save(validate: false)
    end
  end

  def category
    video.category
  end

  def video_title
    video.title
  end

  private

  def review
    @review ||= Review.where(video: video, user: self.user).first
  end

end