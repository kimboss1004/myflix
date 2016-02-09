require 'spec_helper'


describe User do 
  it { should have_many(:reviews)}
  it { should have_many(:queue_items)}
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:full_name)}
  it { should validate_presence_of(:password)}

  describe "#queued_video?" do
    it "returns true if user queued video" do
      kimboss = Fabricate(:user)
      video = Fabricate(:video)
      queue1 = Fabricate(:queue_item, video: video, user: kimboss)
      expect(kimboss.queued_video?(video)).to eq(true)
    end
    it "returns false if user did not queue video" do
      kimboss = Fabricate(:user)
      video = Fabricate(:video)
      expect(kimboss.queued_video?(video)).to eq(false)
    end
  end

end