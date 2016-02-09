require 'spec_helper'

describe QueueItem do
  it { should belong_to(:video)}
  it { should belong_to(:user)}
  it { should validate_numericality_of(:position).only_integer}

  describe "#rating" do
    it "returns nil if there is no review" do
      vid = Fabricate(:video)
      queue_item1 = QueueItem.create(position: 1, video: vid )
      expect(queue_item1.rating).to eq(nil)
    end
    it "returns the rating if user created review of Queued video" do
      kimboss = Fabricate(:user)
      vid = Fabricate(:video)
      review1 = Fabricate(:review, video: vid, user: kimboss)
      queue_item1 = QueueItem.create(position: 1, video: vid, user: kimboss )
      expect(queue_item1.rating).to eq(review1.rating)
    end
    it "returns the earliest rating if user created review of Queued video" do
      kimboss = Fabricate(:user)
      vid = Fabricate(:video)
      review1 = Fabricate(:review, video: vid, user: kimboss)
      review2 = Fabricate(:review, video: vid, user: kimboss)
      review3 = Fabricate(:review, video: vid, user: kimboss)
      queue_item1 = QueueItem.create(position: 1, video: vid, user: kimboss )
      expect(queue_item1.rating).to eq(review1.rating)
    end
  end

  describe "#video_title" do
    it "returns the title of queued video" do
      vid = Fabricate(:video)
      queue_item1 = QueueItem.create(position: 1, video: vid )
      expect(queue_item1.video_title).to eq(queue_item1.video.title)
    end
  end

  describe "#category_name" do
    it "returns the category the queued video" do
      comedy = Category.create(title: "Comedy")
      vid = Fabricate(:video, category: comedy)
      queue_item1 = QueueItem.create(position: 1, video: vid)
      expect(queue_item1.category).to eq(queue_item1.video.category)
    end
  end

  describe "#rating=" do
    it "changes the rating of review if review is present" do
      video = Fabricate(:video)
      kimboss = Fabricate(:user)
      review = Fabricate(:review, video: video, user: kimboss)
      queue1 = Fabricate(:queue_item, video: video, user: kimboss)
      queue1.rating = 2
      expect(queue1.reload.rating).to eq(2)
    end
    it "clears the rating of review if review present and new rating is nil" do
      video = Fabricate(:video)
      kimboss = Fabricate(:user)
      review = Fabricate(:review, video: video, user: kimboss)
      queue1 = Fabricate(:queue_item, video: video, user: kimboss)
      queue1.rating = nil
      expect(queue1.reload.rating).to eq(nil)      
    end
    it "create a review with the rating if review does not exist" do
      video = Fabricate(:video)
      kimboss = Fabricate(:user)
      queue1 = Fabricate(:queue_item, video: video, user: kimboss)
      queue1.rating = 4
      expect(queue1.reload.rating).to eq(4)     
    end
  end

end









