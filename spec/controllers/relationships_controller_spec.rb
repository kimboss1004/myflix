require 'spec_helper'

describe RelationshipsController do

  describe 'POST create' do
    it "creates relationship in database" do
      kimboss = Fabricate(:user)
      joe = Fabricate(:user)
      session[:user_id] = kimboss.id
      post :create, id: joe.id
      expect(Relationship.first.star).to eq(joe)
    end
    it "makes current user the follower" do 
      kimboss = Fabricate(:user)
      joe = Fabricate(:user)
      session[:user_id] = kimboss.id
      post :create, id: joe.id
      expect(Relationship.first.follower).to eq(kimboss)      
    end
    it "does not create relationship if it already exists" do
      kimboss = Fabricate(:user)
      joe = Fabricate(:user)
      session[:user_id] = kimboss.id
      joe.followers << kimboss
      post :create, id: joe.id
      expect(Relationship.all.count).to eq(1) 
    end
    it "does not work if current user follows himself" do
      kimboss = Fabricate(:user)
      joe = Fabricate(:user)
      session[:user_id] = kimboss.id
      post :create, id: kimboss.id
      expect(Relationship.all.count).to eq(0) 
    end
  end

  describe 'DELETE destroy' do
    it "deletes relationship from the database" do
      kimboss = Fabricate(:user)
      joe = Fabricate(:user)
      session[:user_id] = kimboss.id
      joe.followers << kimboss
      delete :destroy, id: joe.id
      expect(Relationship.all.count).to eq(0) 
    end
    it "deletes only valid relationships" do
      kimboss = Fabricate(:user)
      joe = Fabricate(:user)
      session[:user_id] = kimboss.id
      delete :destroy, id: joe.id
      expect(Relationship.all.count).to eq(0) 
    end
    it "delets only users relationship and not others" do
      kimboss = Fabricate(:user)
      joe = Fabricate(:user)
      user_3 = Fabricate(:user)
      joe.followers << user_3
      session[:user_id] = kimboss.id
      delete :destroy, id: joe.id
      expect(Relationship.all.count).to eq(1) 
    end
  end

end