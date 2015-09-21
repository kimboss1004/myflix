require 'spec_helper'

describe Category do
  it { should have_many(:videos)}

  describe "#recent_videos" do
    it "returns empty array if category has 0 videos" do
      documentaries = Category.create(title: "Documentaries")
      expect(documentaries.videos).to eq([])   
    end
    it "returns all videos if there are less than 6" do
      documentaries = Category.create(title: "Documentaries")      
      china_guy = Video.create(title: "Guy from china", description: "bla", category: documentaries)
      family_guy = Video.create(title: "Family Guy", description: "bla", category: documentaries)
      the_guy = Video.create(title: "The Guy", description: "bla", category: documentaries)
      expect(documentaries.recent_videos.size).to eq(3)
    end
    it "returns max 6 videos if there are more than 6 videos" do
      documentaries = Category.create(title: "Documentaries")      
      china_guy = Video.create(title: "Guy from china", description: "bla", category: documentaries)
      family_guy = Video.create(title: "Family Guy", description: "bla", category: documentaries)
      the_guy = Video.create(title: "The Guy", description: "bla", category: documentaries)
      china_kid = Video.create(title: "kid from china", description: "bla", category: documentaries)
      family_kid = Video.create(title: "Family kid", description: "bla", category: documentaries)
      the_kid = Video.create(title: "The kid", description: "bla", category: documentaries)
      china_girl = Video.create(title: "Girl from china", description: "bla", category: documentaries)
      family_girl = Video.create(title: "Family Girl", description: "bla", category: documentaries)
      the_girl = Video.create(title: "The Girl", description: "bla", category: documentaries)
      expect(documentaries.recent_videos.size).to eq(6)
    end
    it "returns most recent videos according to created_at" do
      documentaries = Category.create(title: "Documentaries")      
      china_kid = Video.create(title: "kid from china", description: "bla", category: documentaries)
      family_kid = Video.create(title: "Family kid", description: "bla", category: documentaries)
      the_kid = Video.create(title: "The kid", description: "bla", category: documentaries)
      china_girl = Video.create(title: "Girl from china", description: "bla", category: documentaries)
      family_girl = Video.create(title: "Family Girl", description: "bla", category: documentaries)
      the_girl = Video.create(title: "The Girl", description: "bla", category: documentaries)
      expect(documentaries.recent_videos).to eq([the_girl, family_girl, china_girl, the_kid, family_kid, china_kid])
    end
  end
end 