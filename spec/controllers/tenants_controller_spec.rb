require 'spec_helper'

describe TenantsController do
  include Devise::TestHelpers

  before {
    controller.stub(:authenticate_agent!).and_return true
  }

  describe 'GET :new' do
    before {
      @tenant = create(:tenant)
      @customer = create(:customer, :tenant => @tenant)
      @agent = create(:agent, :tenant => @tenant)
      @conversation1 = create(:conversation, :tenant => @tenant, :customer => @customer, :engaged_agent => @agent)
      @message1 = create(:message, :tenant => @tenant, :conversation => @conversation1, :agent => nil, created_at: '2013-07-25 14:00:00')
      @message2 = create(:message, :tenant => @tenant, :conversation => @conversation1, :agent => @agent, created_at: '2013-07-25 15:00:00')
      @conversation2 = create(:conversation, :tenant => @tenant, :customer => @customer, :engaged_agent => @agent)
      @message3 = create(:message, :tenant => @tenant, :conversation => @conversation2, :agent => nil, created_at: '2013-07-25 14:00:00')
      @message4 = create(:message, :tenant => @tenant, :conversation => @conversation2, :agent => @agent, created_at: '2013-07-25 15:00:00')
      @message5 = create(:message, :tenant => @tenant, :conversation => @conversation2, :agent => nil, created_at: '2013-07-25 16:00:00')
      @message6 = create(:message, :tenant => @tenant, :conversation => @conversation2, :agent => @agent, created_at: '2013-07-25 17:00:00')
      @conversation1.update_attributes(:updated_at => '2013-07-25 14:00:00')
      @conversation2.update_attributes(:updated_at => '2013-07-25 13:00:00')

      sign_in @agent
    }

    it 'should load 2 conversations and 5 messages' do
      get :new
      #expect (response.status).to eq 200
      convs = assigns(:conversations)
      convs[0].id.should eq @conversation1.id
      convs[0].messages.map {|m| m.id}.should eq [@message1.id, @message2.id]
      convs[1].id.should eq @conversation2.id
      convs[1].messages.map {|m| m.id}.should eq [@message3.id, @message4.id, @message5.id, @message6.id]
    end
  end

  describe 'GET :index' do
    before {
      @tenants = (1..3).map { |n| create(:tenant) }
    }

    it 'should get all tenants' do
      get :index
      expect(response.status).to eq(200)
      assigns(:tenants).map { |a| a.id }.should eq @tenants.map { |a| a.id }
    end
  end

  describe 'GET :show' do
    let (:tenants) { (1..3).map { |n| create(:tenant) } }

    it 'should find and return a tenant' do
      get :show, :id => tenants[0].id
      expect(response.status).to eq(200)
      assigns(:tenant).should eq(tenants[0])
    end
    it 'should not find a nonexistent tenant' do
      get :show, :id => 999
      expect(response.status).to eq(404)
    end
  end

  describe 'POST :create' do
    context 'without valid attributes' do
      it 'should not create a tenant when no display name is provided' do
        expect {
          post :create, :tenant => {:twitter_id => 'schrifty', :email => 'marc@gmail.com'}
        }.to change(Tenant, :count).by(0)
        expect(response.status).to eq(422)
      end
    end

    context 'with valid attributes' do
      it 'should create a tenant' do
        expect {
          post :create, :tenant => {:display_name => 'unknown', :twitter_id => 'schrifty', :email => 'marc@gmail.com'}
        }.to change(Tenant, :count).by(1)
        expect(response.status).to eq(201)
      end
    end
  end

  describe 'PUT :update' do
    let (:tenant) { create(:tenant) }

    context 'with valid attributes' do
      it 'should find the tenant' do
        put :update, :tenant => {:twitter_id => 'schrifty'}, :id => tenant.id
        assigns(:tenant).should eq(tenant)
        expect(response.status).to eq(200)
      end

      it 'should update agent attributes' do
        put :update, :tenant => {:twitter_id => 'schrifty'}, :id => tenant.id
        tenant.reload
        tenant.twitter_id.should eq 'schrifty'
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid attributes' do
      it 'should not update a tenant with invalid data' do
        put :update, :tenant => {:display_name => nil}, :id => tenant.id
        expect(response.status).to eq(422)
      end
    end
  end
end