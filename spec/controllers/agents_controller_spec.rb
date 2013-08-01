require 'spec_helper'

describe AgentsController do
  describe 'POST create without tenant' do
    subject { -> {
      post :create, :agent => {:email => 'carlos.danger@acme.com', :available => true, :engaged => true, :display_name => 'Johnny',
                               :encrypted_password => 'blech', :xid => 'abc', :admin => true}
    }}

    it { should change(Tenant, :count).by(1) }
    it { should change(Agent, :count).by(1) }
    #expect(response.status).to eq(201)
  end

  describe 'POST create without tenant and without display name' do
    subject { -> {
      post :create, :agent => {:email => 'carlos.danger@acme.com', :available => true, :engaged => true,
                               :encrypted_password => 'blech', :xid => 'abc', :admin => true}
    }}

    it { should change(Tenant, :count).by(0) }
    it { should change(Agent, :count).by(0) }
    #expect(response.status).to eq(422)
  end

  describe 'POST create' do
    before do
      @tenant = create(:tenant)
    end

    context 'with valid attributes' do
      it 'creates an agent' do
        expect {
          post :create, :agent => {:tenant_id => @tenant.id, :available => true, :engaged => true, :display_name => 'Johnny',
                                   :encrypted_password => 'blech', :xid => 'abc', :admin => true}
        }.to change(Agent, :count).by(1)
        expect(response.status).to eq(201)
      end

      it 'updates an agent' do
        agent = create(:agent)
        put :update, :agent => {:available => false}, :id => agent.id
        expect(response.status).to eq(200)
      end

      it 'updates an agent with invalid data' do
        agent = create(:agent)
        put :update, :agent => {:display_name => nil}, :id => agent.id
        expect(response.status).to eq(422)
      end

      it 'gets all agents' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'gets one agent' do
        agent = create(:agent)
        get :show, :id => agent.id
        expect(response.status).to eq(200)
      end

      it 'should not find a nonexistent agent' do
        get :show, :id => 999
        expect(response.status).to eq(404)
      end
    end

    context 'with invalid attributes' do
      it 'should not create an agent without a display name' do
        expect {
          post :create, agent: {:available => true, :engaged => true,
                                   :encrypted_password => 'blech', :xid => 'abc', :admin => true}
        }.to change(Agent, :count).by(0)
        expect(response.status).to eq(422)
      end
      it 'should not create an agent without a password' do
        expect {
          post :create, agent: {:available => true, :engaged => true, :display_name => 'Johnny',
                                :xid => 'abc', :admin => true}
        }.to change(Agent, :count).by(0)
        expect(response.status).to eq(422)
      end
    end
  end
end