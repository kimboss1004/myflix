class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates :title, presence: true
  validates :description, presence: true


  def self.search_video_title(search_term)
    return [] if search_term.blank?
    Video.where("title LIKE ?", "%#{search_term}%").order('created_at DESC')
  end

  def recent_reviews
    reviews.order('created_at desc')
  end

  def average_rating
    average = 0
    unless reviews.empty?
      reviews.each do |review|
        average += review.rating
      end
      return (average / reviews.size)
    end
    return nil
  end

end