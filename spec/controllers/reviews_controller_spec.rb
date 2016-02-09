require 'spec_helper'

describe ReviewsController do 

  describe 'POST create' do
    context "with unauthenticated user" do
      it "redirects to login page if user is not authenticated" do
        vid = Fabricate(:video)
        post :create, video_id: vid.id
        expect(response).to redirect_to login_path
      end    
    end

    context "with authenticated user" do
      context "with valid submission" do
        it 'creates review in database' do
          session[:user_id] = Fabricate(:user).id
          vid = Fabricate(:video)
          post :create, video_id: vid.id, review: Fabricate.attributes_for(:review)
          expect(assigns(:review)).to eq(Review.first)
        end
        it 'sets @review associated to @video' do
          session[:user_id] = Fabricate(:user).id
          vid = Fabricate(:video)
          post :create, video_id: vid.id, review: Fabricate.attributes_for(:review)
          expect(assigns(:review).video).to eq(vid)
        end
        it 'creates @review associated to current user' do
          session[:user_id] = Fabricate(:user).id
          vid = Fabricate(:video)
          post :create, video_id: vid.id, review: Fabricate.attributes_for(:review)
          expect(assigns(:review).user.id).to eq(session[:user_id])
        end
        it "redirects to videos/show page" do
          session[:user_id] = Fabricate(:user).id
          vid = Fabricate(:video)
          post :create, video_id: vid.id, review: Fabricate.attributes_for(:review)
          expect(response).to redirect_to(video_path(vid))
        end
      end

      context "with invalid submission" do  
        it "does not create review" do
          session[:user_id] = Fabricate(:user).id
          vid = Fabricate(:video)
          post :create, video_id: vid.id, review: { description: "blablabla" }
          expect(Review.first).to eq(nil)
        end
        it "renders videos/show page" do
          session[:user_id] = Fabricate(:user).id
          vid = Fabricate(:video)
          post :create, video_id: vid.id, review: { description: "blablabla" }
          expect(response).to render_template 'videos/show'
        end
        it "sets @video" do
          session[:user_id] = Fabricate(:user).id
          vid = Fabricate(:video)
          post :create, video_id: vid.id, review: { description: "blablabla" }
          expect(assigns(:video)).to eq(vid)  
        end
      end
    end

  end

end

