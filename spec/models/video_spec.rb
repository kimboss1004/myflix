require 'spec_helper'


describe Video do 
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}

  describe "search_video_title" do
    it 'returns array of no videos' do
      expect(Video.search_video_title("Adventure Time")).to eq([])
    end
    it "returns array of one video" do
      video = Video.create(title: "Adventure Time", description: "bla")
      expect(Video.search_video_title(video.title)).to eq([video])
    end 
    it "returns array of one video for partial match" do
      video = Video.create(title: "Adventure Time", description: "bla")
      expect(Video.search_video_title("Time")).to eq([video])
    end
    it "returns array of all videos for a partial match" do
      china_guy = Video.create(title: "Guy from china", description: "bla")
      family_guy = Video.create(title: "Family Guy", description: "bla")
      the_guy = Video.create(title: "The Guy", description: "bla")
      expect(Video.search_video_title("Guy")).to eq([the_guy, family_guy, china_guy])
    end
    it "returns empty array if search term is empty" do
      expect(Video.search_video_title("")).to eq([])
    end
  end

  describe "recent_reviews" do
    it "returns empty [] if there are no reviews" do
      vid = Fabricate(:video)
      expect(vid.recent_reviews).to eq([])
    end
    it "returns 1 review" do
      vid = Fabricate(:video)
      review = Fabricate(:review, video: vid)
      expect(vid.recent_reviews).to eq([review])
    end
    it "returns multiple reviews ordered by created_at" do
      vid = Fabricate(:video)
      review1 = Fabricate(:review, video: vid) 
      review2 = Fabricate(:review, video: vid) 
      review3 = Fabricate(:review, video: vid)  
      expect(vid.recent_reviews).to eq([review3, review2, review1])
    end   
  end

  describe "average_rating" do
    it "returns nil if there are no reviews" do
      vid = Fabricate(:video)
      expect(vid.average_rating).to eq(nil)
    end
    it "returns zero if average rating is zero" do
      vid = Fabricate(:video)
      review1 = Fabricate(:review, video: vid, rating: 0) 
      review2 = Fabricate(:review, video: vid, rating: 0) 
      review3 = Fabricate(:review, video: vid, rating: 0)
      expect(vid.average_rating).to eq(0)
    end
    it "returns the average of all its ratings" do
      vid = Fabricate(:video)
      review1 = Fabricate(:review, video: vid, rating: 5) 
      review2 = Fabricate(:review, video: vid, rating: 1) 
      review3 = Fabricate(:review, video: vid, rating: 3)
      expect(vid.average_rating).to eq(3)  
    end
  end



end