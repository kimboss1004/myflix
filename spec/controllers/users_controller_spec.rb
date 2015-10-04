require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it "sets new @user intance if user is not authenticated" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
    it "redirects to categories path if user is authenticated" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to categories_path
    end
  end

  describe 'POST create' do
    context "with valid input" do
      it "creates @user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(assigns(:user)).to eq(User.first)
      end
      it "redirects to login page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid input" do
      it "does not create @user" do
        post :create, user: {email: "ace@gmail.com" }
        expect(assigns(:user).valid?).to eq(false)
      end
      it "sets @user" do
        post :create, user: {email: "ace@gmail.com" }
        expect(assigns(:user)).to be_instance_of(User)
      end
      it "renders :new page" do
        post :create, user: {email: "ace@gmail.com" }
        expect(response).to render_template :new
      end
    end
  end
end