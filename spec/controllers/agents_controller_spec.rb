require 'spec_helper'

describe AgentsController do
  include Devise::TestHelpers

  before {
    controller.stub(:authenticate_agent!).and_return true
    @tenant1 = create(:tenant)
  }

  describe 'GET :index' do
    before {
      @agents = (1..3).map { |n| create(:agent, :tenant => @tenant1) }
    }

    it 'should get all agents' do
      get :index
      expect(response.status).to eq(200)
      assigns(:agents).map { |a| a.id }.should eq @agents.map { |a| a.id }
    end

    it 'should return an agent by email' do
      get :index, :email => @agents[0].email
      expect(response.status).to eq(200)
      expect(assigns(:agents).size).to eq(1)
      expect(assigns(:agents)[0].email).to eq(@agents[0].email)
    end

    it 'should return a 404 when looking for an unregistered email' do
      get :index, :email => 'blah@blah.com'
      expect(assigns(:agents).size).to eq(0)
    end
  end

  describe 'GET :show' do
    let (:agents) { (1..3).map { |n| create(:agent, :tenant => @tenant1) } }

    it 'should find and return an agent' do
      get :show, :id => agents[0].id
      expect(response.status).to eq(200)
      assigns(:agent).should eq(agents[0])
    end

    it 'should return a 404 when looking for a nonexistent agent' do
      get :show, :id => 999
      expect(response.status).to eq(404)
    end
  end

  describe 'GET :show_current_agent' do
    context 'signed out' do
      it 'should find and return an agent' do
        get :show_current_agent
        expect(response.status).to eq(404)
        assigns(:agent).should eq(nil)
      end
    end

    context 'signed in' do
      before {
        @agent1 = create(:agent, :tenant => @tenant1)
        sign_in @agent1
      }

      it 'should find and return an agent' do
        get :show_current_agent
        expect(response.status).to eq(200)
        assigns(:agent).should eq(@agent1)
      end
    end
  end

  describe 'HEAD show' do
    let (:agent) { create(:agent, :tenant => @tenant1) }

    it 'should return one agent' do
      head :show, :id => agent.id
      expect(response.status).to eq(200)
    end

    it 'should return a 404 when looking for a nonexistent agent' do
      head :show, :id => 999
      expect(response.status).to eq(404)
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      context 'without a tenant' do
        it 'should create a new tenant' do
          expect {
            post :create, :agent => {:email => 'carlos.danger@acme.com', :available => true, :engaged => true, :display_name => 'Johnny',
                                     :password => 'blechball', :xid => 'abc', :admin => true}
          }.to change(Tenant, :count).by(1)
          expect(response.status).to eq(201)
        end

        it 'should create a new agent' do
          expect {
            post :create, :agent => {:email => 'carlos.danger@acme.com', :available => true, :engaged => true, :display_name => 'Johnny',
                                     :password => 'blechball', :xid => 'abc', :admin => true}
          }.to change(Agent, :count).by(1)
          expect(response.status).to eq(201)
        end

        #it 'should return a 201' do
        #  expect {
        #    post :create, :agent => {:email => 'carlos.danger@acme.com', :available => true, :engaged => true, :display_name => 'Johnny',
        #                             :password => 'blechball', :xid => 'abc', :admin => true}
        #  }
        #  expect(response.status).to eq(201)
        #end
      end

      context 'with a tenant' do
        it 'should create an agent' do
          expect {
            post :create, :agent => {:tenant_id => @tenant1.id, :available => true, :engaged => true, :display_name => 'Johnny',
                                     :password => 'blechball', :email => 'schrifty@gmail.com', :xid => 'abc', :admin => true}
          }.to change(Agent, :count).by(1)
          expect(response.status).to eq(201)
        end
      end
    end

    context 'with invalid attributes' do
      context 'without a tenant or a display_name' do
        it 'should not create a tenant' do
          expect {
            post :create, :agent => {:email => 'carlos.danger@acme.com', :available => true, :engaged => true,
                                     :password => 'blechball', :xid => 'abc', :admin => true}
          }.to change(Tenant, :count).by(0)
          expect(response.status).to eq(422)
        end

        it 'should not create an agent' do
          expect {
            post :create, :agent => {:email => 'carlos.danger@acme.com', :available => true, :engaged => true,
                                     :password => 'blechball', :xid => 'abc', :admin => true}
          }.to change(Agent, :count).by(0)
          expect(response.status).to eq(422)
        end
      end

      context 'with a tenant' do
        it 'should not create an agent without an email' do
          expect {
            post :create, agent: {:available => true, :engaged => true, :display_name => 'Bob',
                                  :password => 'blechball', :xid => 'abc', :admin => true}
          }.to change(Agent, :count).by(0)
          expect(response.status).to eq(422)
        end
        it 'should not create an agent without a display name' do
          expect {
            post :create, agent: {:available => true, :engaged => true,
                                  :password => 'blechball', :xid => 'abc', :admin => true}
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

  describe 'PUT update' do
    let (:agent) { create(:agent, :tenant => @tenant1) }

    context 'with valid attributes' do
      it 'should find the agent' do
        put :update, :agent => {:available => false}, :id => agent.id
        assigns(:agent).should eq(agent)
        expect(response.status).to eq(200)
      end

      it 'should update agent attributes' do
        put :update, :agent => {:available => false, :display_name => 'Carlos', :engaged => true}, :id => agent.id
        agent.reload
        agent.available.should eq 0
        agent.display_name.should eq 'Carlos'
        agent.engaged.should eq true
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid attributes' do
      it 'should not update an agent with invalid data' do
        put :update, :agent => {:display_name => nil}, :id => agent.id
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE destroy' do
    before {
      @agent = create(:agent, :tenant => @tenant1)
    }

    it 'should delete the agent' do
      expect {
        delete :destroy, :id => @agent.id
      }.to change(Agent, :count).by(-1)
    end
  end
end
