require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video variable if user is authenticated" do
      session[:user_id] = Fabricate(:user).id
      vid = Fabricate(:video)
      get :show, id: vid.id
      expect(assigns(:video)).to eq(vid)
    end

    it "redirects user to login page if user is not authenticated" do
      vid = Fabricate(:video)
      get :show, id: vid.id
      expect(response).to redirect_to login_path
    end

    it "sets new @review variable if user is authenticated" do
      session[:user_id] = Fabricate(:user).id
      vid = Fabricate(:video)
      get :show, id: vid.id
      expect(assigns(:review)).to be_instance_of(Review)
    end

    it "sets @reviews of @video.recent_reviews if user authenticated" do
      session[:user_id] = Fabricate(:user).id
      vid = Fabricate(:video)
      review1 = Fabricate(:review, video: vid)
      review2 = Fabricate(:review, video: vid)
      get :show, id: vid.id
      expect(assigns(:reviews)).to eq([review2, review1])
    end
  end

  describe "GET search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      pokemon = Fabricate(:video, title: "Pokemon")
      vid1 = Fabricate(:video)
      get :search, search: "Pokemon"
      expect(assigns(:results)).to eq([pokemon])
    end
    it "redirects to login page for unauthenticated users" do
      pokemon = Fabricate(:video, title: "Pokemon")
      vid1 = Fabricate(:video) 
      get :search, search: "Pokemon"
      expect(response).to redirect_to login_path     
    end
  end
end