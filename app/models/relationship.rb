class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User", foreign_key: "follower_id"
  belongs_to :star, class_name: "User", foreign_key: "star_id"

end