class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order(:position) }
  has_secure_password validations: false

  has_many :follower_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :star_relationships, class_name: "Relationship", foreign_key: "star_id"

  has_many :followers, through: :star_relationships, source: :follower
  has_many :stars, through: :follower_relationships, source: :star

  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true, uniqueness: true
  validates :password, presence: true

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: (index+1))
    end    
  end

  def queued_video?(video)
    !queue_items.where(video_id: video.id).empty?
  end

end