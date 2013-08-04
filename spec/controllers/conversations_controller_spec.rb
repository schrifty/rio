require 'spec_helper'

describe ConversationsController do
  before {
    @tenant1 = create(:tenant)
    @customer1 = create(:customer)
  }

  describe 'GET :index' do
    before {
      @conversations = (1..3).map { |n| create(:conversation, :tenant => @tenant1, :customer => @customer1) }
    }

    it 'should get all conversations' do
      get :index
      expect(response.status).to eq(200)
      assigns(:conversations).map { |c| c.id }.should eq @conversations.map { |c| c.id }
    end
  end

  describe 'GET :show' do
    let (:conversations) { (1..3).map { |n| create(:conversation, :tenant => @tenant1, :customer => @customer1) } }

    it 'should find and return a conversation' do
      get :show, :id => conversations[0].id
      expect(response.status).to eq(200)
      assigns(:conversation).should eq(conversations[0])
    end

    it 'should return a 404 when looking for a nonexistent conversation' do
      get :show, :id => 999
      expect(response.status).to eq(404)
    end
  end

  describe 'POST create' do
    before do
      @tenant = create(:tenant)
      @customer = create(:customer)
    end

    context 'with valid attributes' do
      it 'should create a conversation' do
        expect {
          post :create, :conversation => {:tenant_id => @tenant.id, :customer_id => @customer.id, :active => true, :referer_url => 'http:'}
        }.to change(Conversation, :count).by(1)
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid attributes' do
      it 'should not create a conversation' do
        expect {
          post :create, conversation: {:customer_id => @customer.id, :active => true, :referer_url => 'http:'}
        }.to change(Conversation, :count).by(0)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT :update' do
    let (:conversation) { create(:conversation) }
    let (:agent) { create(:agent, :tenant => @tenant1) }

    context 'with valid attributes' do
      it 'should find the conversation' do
        put :update, :conversation => {:active => false}, :id => conversation.id
        assigns(:conversation).should eq(conversation)
        expect(response.status).to eq(200)
      end

      it 'should update agent attributes' do
        put :update, :conversation => {:active => false, :referer_url => 'www.wow.com', :engaged_agent_id => agent.id}, :id => conversation.id
        conversation.reload
        conversation.active.should eq false
        conversation.referer_url.should eq 'www.wow.com'
        conversation.engaged_agent.id.should eq agent.id
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid attributes' do
      it 'should not update a conversation' do
        conversation = create(:conversation)
        put :update, :conversation => {:customer_id => nil}, :id => conversation.id
        expect(response.status).to eq(422)
      end
    end
  end
end