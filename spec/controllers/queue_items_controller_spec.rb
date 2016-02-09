require 'spec_helper'

describe QueueItemsController do
  
  describe "GET index" do
    it "sets @queue_items ordered by position" do
      kimboss = Fabricate(:user)
      set_current_user(kimboss)
      vid = Fabricate(:video)
      queue1 = Fabricate(:queue_item, video: vid, user: kimboss, position: 1)
      queue3 = Fabricate(:queue_item, video: vid, user: kimboss, position: 3)
      queue2 = Fabricate(:queue_item, video: vid, user: kimboss, position: 2)
      get :index
      expect(assigns(:queue_items)).to eq([queue1,queue2,queue3])
    end
    it "redirects to login if user is not authenticated" do
      get :index
      expect(response).to redirect_to login_path
    end 
  end

  describe "POST create" do
    it "redirects to login if user is not authenticated" do
      post :create
      expect(response).to redirect_to login_path
    end 
    it "creates queue item in database" do
      kimboss = Fabricate(:user)
      set_current_user(kimboss)
      vid = Fabricate(:video)
      post :create, video_id: vid.id  
      expect(QueueItem.count).to eq(1)
    end
    it "redirects to queue_item index page" do
      kimboss = Fabricate(:user)
      set_current_user(kimboss)
      vid = Fabricate(:video)
      post :create, video_id: vid.id
      expect(response).to redirect_to queue_items_path
    end
    it "associates video with queue item " do
      kimboss = Fabricate(:user)
      set_current_user(kimboss)
      vid = Fabricate(:video)
      post :create, video_id: vid.id  
      expect(QueueItem.first.video).to eq(vid) 
    end
    it "associates user with queue item" do
      kimboss = Fabricate(:user)
      set_current_user(kimboss)
      vid = Fabricate(:video)
      post :create, video_id: vid.id  
      expect(QueueItem.first.user).to eq(kimboss) 
    end
    it "makes video last in queue" do
        kimboss = Fabricate(:user)
        set_current_user(kimboss)
        vid = Fabricate(:video)
        queue1 = Fabricate(:queue_item, user: kimboss, video: vid, position: 1)
        vid2 = Fabricate(:video)
        post :create, video_id: vid2.id  
        queued_item_of_vid2 = QueueItem.where(video_id: vid2.id, user_id: kimboss.id).first
        expect(queued_item_of_vid2.position).to eq(2) 
    end
    it "does not add queue item for specific video if it is already in users queue" do
        kimboss = Fabricate(:user)
        set_current_user(kimboss)
        vid = Fabricate(:video)
        queue1 = Fabricate(:queue_item, user: kimboss, video: vid, position: 1)
        post :create, video_id: vid.id  
        expect(QueueItem.count).to eq(1) 
    end

    describe "DELETE destroy" do
      it "redirects back to queue_items page" do
        kimboss = Fabricate(:user)
        set_current_user(kimboss)
        queue1 = Fabricate(:queue_item, user: kimboss)
        delete :destroy, id: queue1.id
        expect(response).to redirect_to queue_items_path 
      end
      it "deletes queue_item from database" do
        kimboss = Fabricate(:user)
        set_current_user(kimboss)
        queue1 = Fabricate(:queue_item, user: kimboss)
        delete :destroy, id: queue1.id
        expect(kimboss.queue_items.count).to eq(0)
      end
      it "does not delete queue item of a different user" do
        kimboss = Fabricate(:user)
        another_user = Fabricate(:user)
        set_current_user(kimboss)
        queue1 = Fabricate(:queue_item, user: another_user)
        delete :destroy, id: queue1.id
        expect(QueueItem.count).to eq(1)
      end
      it "normalizes queue items" do
        kimboss = Fabricate(:user)
        set_current_user(kimboss)
        queue1 = Fabricate(:queue_item, user: kimboss, position:1)
        queue2 = Fabricate(:queue_item, user: kimboss, position: 2)
        queue3 = Fabricate(:queue_item, user: kimboss, position: 3)
        delete :destroy, id: queue1.id
        expect(kimboss.queue_items.map{|q| q.position}).to eq([1,2])
      end
      it "redirects unauthenticated users to sign in page" do
        delete :destroy, id: 1
        expect(response).to redirect_to login_path
      end
    end

    describe "PUT update" do
      context "with valid inputs"
      it "redirects back to the queue item page" do
        kimboss = Fabricate(:user)
        set_current_user(kimboss)
        queue1 = Fabricate(:queue_item, position: 1)
        queue2 = Fabricate(:queue_item, position: 2)
        queue3 = Fabricate(:queue_item, position: 3)
        put :update_queue, queue_items: [{id: queue1.id, position: 1},{id: queue2.id, position: 3},{id: queue3.id, position: 3}]
        expect(response).to redirect_to queue_items_path
      end

      it "saves all positions of queue items" do
        kimboss = Fabricate(:user)
        set_current_user(kimboss)
        queue1 = Fabricate(:queue_item, position: 1, user: kimboss)
        queue2 = Fabricate(:queue_item, position: 2, user: kimboss)
        put :update_queue, queue_items: [{id: queue1.id, position: 2},{id: queue2.id, position: 1}]
        expect(kimboss.queue_items).to eq([queue2, queue1])
      end
      it "normalizes the queue item positions" do
        kimboss = Fabricate(:user)
        set_current_user(kimboss)
        queue1 = Fabricate(:queue_item, position: 1, user: kimboss)
        queue2 = Fabricate(:queue_item, position: 2, user: kimboss)
        put :update_queue, queue_items: [{id: queue1.id, position: 3},{id: queue2.id, position: 2}]
        expect(kimboss.queue_items.map{ |q| q.position }).to eq([1,2])
      end
      context "with invalid inputs" do
        it "redirects to queue items page" do
          kimboss = Fabricate(:user)
          set_current_user(kimboss)
          queue1 = Fabricate(:queue_item, position: 1, user: kimboss)
          queue2 = Fabricate(:queue_item, position: 2, user: kimboss)
          put :update_queue, queue_items: [{id: queue1.id, position: 3},{id: queue2.id, position: 2.4}]
          expect(response).to redirect_to queue_items_path
        end
        it "does not update queue items" do
          kimboss = Fabricate(:user)
          set_current_user(kimboss)
          queue1 = Fabricate(:queue_item, position: 1, user: kimboss)
          queue2 = Fabricate(:queue_item, position: 2, user: kimboss)
          put :update_queue, queue_items: [{id: queue1.id, position: 3},{id: queue2.id, position: 2.4}]
          expect(queue1.reload.position).to eq(1)
        end
        it "creates flash danger message" do
          kimboss = Fabricate(:user)
          set_current_user(kimboss)
          queue1 = Fabricate(:queue_item, position: 1, user: kimboss)
          queue2 = Fabricate(:queue_item, position: 2, user: kimboss)
          put :update_queue, queue_items: [{id: queue1.id, position: 3},{id: queue2.id, position: 2.4}]
          expect(flash[:danger]).to be_present       
        end
      end
      context "with unauthenticated user" do
        it "redirect to login page" do
          put :update_queue
          expect(response).to redirect_to login_path  
        end
      end
      context "with queue_items that do not belong to user" do
        it "queue items are not updated/changed" do
          kimboss = Fabricate(:user)
          joey = Fabricate(:user)
          set_current_user(kimboss)
          queue1 = Fabricate(:queue_item, position: 1, user: joey)
          queue2 = Fabricate(:queue_item, position: 2, user: joey)
          put :update_queue, queue_items: [{id: queue1.id, position: 3},{id: queue2.id, position: 2}]
          expect(queue1.reload.position).to eq(1)  
        end
      end

    end

  end

end






