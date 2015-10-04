require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to login if user authenticated" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to categories_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      it "finds @user" do
        kimboss = Fabricate(:user)
        post :create, email: kimboss.email
        expect(assigns(:user)).to eq(kimboss)
      end
      it "saves user_id in session" do
        kimboss = Fabricate(:user)
        post :create, email: kimboss.email, password: kimboss.password
        expect(session[:user_id]).to eq(kimboss.id)
      end
    end

    context "with invalid credentials" do
      it "has empty session[:user_id]" do
        kimboss = Fabricate(:user)
        post :create, email: kimboss.email, password: kimboss.password + "wrongpassword"
        expect(session[:user_id]).to eq(nil)
      end
      it "redirects to login_path" do
        kimboss = Fabricate(:user)
        post :create, email: kimboss.email, password: kimboss.password + "wrongpassword"
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "DELETE destroy" do
    it "clears session[:user_id] for user" do
      session[:user_id] = Fabricate(:user).id
      delete :destroy
      expect(session[:user_id]).to eq(nil)
    end
  end
end