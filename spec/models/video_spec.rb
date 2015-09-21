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

end