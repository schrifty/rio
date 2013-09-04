require 'spec_helper'

describe ConversationsController do
  include Devise::TestHelpers

  before {
    controller.stub(:authenticate_agent!).and_return true
    @tenant1 = create(:tenant)
    @tenant2 = create(:tenant)
    @tenant3 = create(:tenant)

    @agent1 = create(:agent, :tenant => @tenant1)
    @agent2 = create(:agent, :tenant => @tenant2)

    @customer1 = create(:customer, :tenant => @tenant1)
    @customer2 = create(:customer, :tenant => @tenant2)

    @conversation1 = create(:conversation, :tenant => @tenant1, :customer => @customer1)
    @message1 = create(:message, :tenant => @tenant1, :conversation => @conversation1, :agent => nil)

    @conversation2 = create(:conversation, :tenant => @tenant2, :customer => @customer2)
    @message2 = create(:message, :tenant => @tenant2, :conversation => @conversation2, :agent => nil)

    @conversations = [@conversation1, @conversation2] + (1..10).map { |n|
      tenant = [@tenant1, @tenant2, @tenant3][rand(3)]
      customer = create(:customer, :tenant => tenant)
      conversation = create(:conversation, :tenant => tenant, :customer => customer)
      create(:message, :tenant => tenant, :conversation => conversation, :agent => nil)
      conversation
    }
  }

  describe 'GET :index' do
    before {
      sign_in @agent1
    }

    it 'should get all and only all of the conversations the user is permitted to see' do
      get :index, :format => :json
      expect(response.status).to eq(200)
      assigns(:conversations).map { |a| a.id }.should eq @conversations.select { |a| a.tenant == @conversation1.tenant }.map { |a| a.id }
    end
  end

  describe 'GET :show' do
    before {
      sign_in @agent1
    }

    it 'should find and return a conversation' do
      get :show, :id => @conversation1.id
      expect(response.status).to eq 200
      assigns(:conversation).should eq @conversation1
    end

    it 'should not find and return a conversation from another tenant' do
      get :show, :id => @conversation2.id
      expect(response.status).to eq 404
    end

    it 'should return a 404 when looking for a nonexistent conversation' do
      get :show, :id => 999
      expect(response.status).to eq 404
    end
  end

  describe 'POST create' do
    before {
      sign_in @agent1
    }

    it 'should create a valid conversation' do
      expect {
        post :create, :conversation => {:tenant_id => @tenant1.id, :customer_id => @customer1.id, :resolved => false, :referer_url => 'http:'}
      }.to change(Conversation, :count).by(1)
      expect(response.status).to eq(201)
    end

    it 'should not create a conversation without a tenant' do
      expect {
        post :create, conversation: {:customer_id => @customer1.id, :resolved => false, :referer_url => 'http:'}
      }.to change(Conversation, :count).by 0
      expect(response.status).to eq 422
    end

    it 'should not create a conversation with a forbidden engaged_agent' do
      expect {
        post :create, :conversation => {:tenant_id => @tenant1.id, :customer_id => @customer1.id, :resolved => false, :engaged_agent_id => @agent2.id}
      }.to change(Conversation, :count).by 0
      expect(response.status).to eq 422
    end

    it 'should not create a conversation with a forbidden target_agent' do
      expect {
        post :create, :conversation => {:tenant_id => @tenant1.id, :customer_id => @customer1.id, :resolved => false, :target_agent_id => @agent2.id}
      }.to change(Conversation, :count).by 0
      expect(response.status).to eq 422
    end

    # FYI how does this work?
    it 'should not create a conversation with a forbidden tenant' do
      expect {
        post :create, conversation: {:tenant_id => @tenant2.id, :customer_id => @customer1.id, :resolved => false, :referer_url => 'http:'}
      }.to change(Conversation, :count).by 0
      expect(response.status).to eq 422
    end

    it 'should not create a conversation with a forbidden customer' do
      expect {
        post :create, conversation: {:tenant_id => @tenant1.id, :customer_id => @customer2.id, :resolved => false, :referer_url => 'http:'}
      }.to change(Conversation, :count).by(0)
      expect(response.status).to eq(422)
    end
  end

  describe 'PUT :update' do
    before {
      sign_in @agent1
    }

    it 'should find the conversation' do
      put :update, :conversation => {:resolved => true}, :id => @conversation1.id
      assigns(:conversation).should eq @conversation1
      expect(response.status).to eq 200
    end

    it 'should update agent attributes' do
      put :update, :conversation => {:resolved => true, :referer_url => 'www.wow.com', :engaged_agent_id => @agent1.id}, :id => @conversation1.id
      @conversation1.reload
      @conversation1.resolved.should eq true
      @conversation1.referer_url.should eq 'www.wow.com'
      @conversation1.engaged_agent.id.should eq @agent1.id
      expect(response.status).to eq 200
    end

    it 'should not find a forbidden conversation' do
      put :update, :conversation => {:resolved => true}, :id => @conversation2.id
      expect(response.status).to eq 403
    end

    it 'should not allow a conversation customer to be updated' do
      put :update, :conversation => {:customer_id => @customer2.id}, :id => @conversation1.id
      expect(@conversation1.reload.customer.id).to eq @customer1.id
    end

    it 'should not allow a conversation to be updated with an invalid engaged_agent' do
      put :update, :conversation => {:engaged_agent_id => @agent2.id}, :id => @conversation1.id
      expect(response.status).to eq 422
    end

    it 'should not allow a conversation to be updated with an invalid target_agent' do
      put :update, :conversation => {:target_agent_id => @agent2.id}, :id => @conversation1.id
      expect(response.status).to eq 422
    end
  end
end