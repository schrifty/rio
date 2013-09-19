require 'spec_helper'

describe MessagesController do
  include Devise::TestHelpers

  before {
    controller.stub(:authenticate_agent!).and_return true
    @tenant1 = create(:tenant)
    @tenant2 = create(:tenant)
    @tenant3 = create(:tenant)

    @agent1 = create(:agent, :tenant => @tenant1)
    sign_in @agent1
    @agent2 = create(:agent, :tenant => @tenant2)

    @customer1 = create(:customer, :tenant => @tenant1)
    @customer2 = create(:customer, :tenant => @tenant2)

    @conversation1 = create(:conversation, :tenant => @tenant1, :customer => @customer1)
    @conversation2 = create(:conversation, :tenant => @tenant2, :customer => @customer2)

    @message1 = create(:message, :tenant => @tenant1, :conversation => @conversation1, :agent => @agent1)
    @message2 = create(:message, :tenant => @tenant2, :conversation => @conversation2, :agent => @agent2)
    @messages = [@message1, @message2] + (1..10).map { |n|
      tenant = [@tenant1, @tenant2, @tenant3][rand(3)]
      customer = create(:customer, :tenant => tenant)
      conversation = create(:conversation, :tenant => tenant, :customer => customer)
      agent = create(:agent, :tenant => tenant)
      create(:message, :tenant => tenant, :conversation => conversation, :agent => agent)
    }
  }

  describe 'GET :index' do
    it 'should get all and only all of the messages the user is permitted to see' do
      get :index
      expect(response.status).to eq 200
      (assigns(:messages).map { |m| m.id } - @messages.select { |m| m.tenant == @tenant1 }.map { |m| m.id }).should eq []
    end

    it 'should get messages in order of created_at desc' do
      get :index
      expect(response.status).to eq 200
      puts @messages.select{|m| m.tenant == @tenant1}.sort{|a, b| b.created_at <=> a.created_at}.map{ |m| m.created_at }.inspect
      last_created_at = nil
      assigns(:messages).each{|m|
        m.created_at.should be <= last_created_at if last_created_at
        last_created_at = m.created_at
      }
    end
  end

  describe 'GET :show' do
    it 'should find and return one message' do
      get :show, :id => @message1.id
      expect(response.status).to eq 200
      assigns(:message).should eq @message1
    end

    it 'should not find and return a forbidden message' do
      get :show, :id => @message2.id
      expect(response.status).to eq 404
    end

    it 'should not find a nonexistent message' do
      get :show, :id => 999
      expect(response.status).to eq 404
    end
  end

  describe 'POST create' do
    it 'should create a new message' do
      expect {
        post :create, :message => {:tenant_id => @tenant1.id, :conversation_id => @conversation1.id, :agent_id => @agent1.id,
                                   :sent_by => 'twitter', :text => 'This is the message'}
      }.to change(Message, :count).by(1)
      expect(response.status).to eq(201)
    end

    it 'should not create a message without a tenant' do
      expect {
        post :create, message: {:conversation_id => @conversation1.id, :agent_id => @agent1.id, :sent_by => 'twitter',
                                :text => 'This is the message'}
      }.to change(Message, :count).by(0)
      expect(response.status).to eq(422)
    end

    it 'should not create a message without text' do
      expect {
        post :create, message: {:tenant_id => @tenant1.id, :conversation_id => @conversation1.id, :agent_id => @agent1.id,
                                :sent_by => 'twitter'}
      }.to change(Message, :count).by(0)
      expect(response.status).to eq(422)
    end

    it 'should not create a message with a forbidden conversation' do
      expect {
        post :create, message: {:tenant_id => @tenant1.id, :conversation_id => @conversation2.id, :agent_id => @agent1.id,
                                :sent_by => 'twitter', :text => 'test'}
      }.to change(Message, :count).by(0)
      expect(response.status).to eq(422)
    end

    it 'should not create a message with a forbidden agent' do
      expect {
        post :create, message: {:tenant_id => @tenant1.id, :conversation_id => @conversation1.id, :agent_id => @agent2.id,
                                :sent_by => 'twitter', :text => 'test'}
      }.to change(Message, :count).by(0)
      expect(response.status).to eq(422)
    end
  end
end