require 'spec_helper'

describe AgentsController do
  include Devise::TestHelpers

  before {
    controller.stub(:authenticate_agent!).and_return true
    @tenant1 = create(:tenant)
    @tenant2 = create(:tenant)
    @tenant3 = create(:tenant)
  }

  describe 'GET :index' do
    before {
      @agent1 = create(:agent, :tenant => @tenant2)
      @agent2 = create(:agent, :tenant => @tenant3)
      @agents = [@agent1, @agent2] + (1..10).map { |n|
        create(:agent, :tenant =>  [@tenant1, @tenant2, @tenant3][rand(3)])
      }
      sign_in @agent1
    }

    it 'should get all and only all of the agents the user is permitted to see' do
      get :index
      expect(response.status).to eq 200
      (assigns(:agents).map { |a| a.id } - @agents.select{|a| a.tenant == @agent1.tenant}.map { |a| a.id }).should eq []
    end

    it 'should return an agent by email' do
      get :index, :email => @agent1.email
      expect(response.status).to eq(200)
      expect(assigns(:agents).size).to eq(1)
      expect(assigns(:agents)[0].email).to eq(@agent1.email)
    end

    it 'should not return an agent from another tenant' do
      get :index, :email => @agent2.email
      expect(response.status).to eq(200)
      expect(assigns(:agents).size).to eq(0)
    end

    it 'should return a 404 when looking for an unregistered email' do
      get :index, :email => 'blah@blah.com'
      expect(assigns(:agents).size).to eq(0)
    end
  end

  describe 'GET :show' do
    before {
      @agent1 = create(:agent, :tenant => @tenant1)
      @agent2 = create(:agent, :tenant => @tenant2)
      sign_in @agent1
    }

    let (:agents) { (1..3).map { |n| create(:agent, :tenant => @tenant1) } }

    it 'should find and return an agent' do
      get :show, :id => @agent1.id
      expect(response.status).to eq(200)
      assigns(:agent).should eq(@agent1)
    end

    it 'should not find and return an agent from another tenant' do
      get :show, :id => @agent2.id
      expect(response.status).to eq(404)
    end

    it 'should return a 404 when looking for a nonexistent agent' do
      get :show, :id => 999
      expect(response.status).to eq(404)
    end
  end

  describe 'GET :show_current_agent' do
    #context 'signed out' do
    #  it 'should find and return an agent' do
    #    get :show_current_agent
    #    expect(response.status).to eq(404)
    #    assigns(:agent).should eq(nil)
    #  end
    #end

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

  describe 'HEAD :show' do
    before {
      @agent1 = create(:agent, :tenant => @tenant1)
      @agent2 = create(:agent, :tenant => @tenant2)
      sign_in @agent1
    }

    it 'should find an agent' do
      head :show, :id => @agent1.id
      expect(response.status).to eq(200)
    end

    it 'should return a 404 when searching for an agent from another tenant' do
      head :show, :id => @agent2.id
      expect(response.status).to eq(404)
    end

    it 'should return a 404 when looking for a nonexistent agent' do
      head :show, :id => 999
      expect(response.status).to eq(404)
    end
  end

  describe 'POST :create' do
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

  describe 'PUT:update' do
    before {
      @agent1 = create(:agent, :tenant => @tenant1)
      @agent2 = create(:agent, :tenant => @tenant2)
      sign_in @agent1
    }

    context 'with valid attributes' do
      it 'should find the agent' do
        put :update, :agent => {:available => false}, :id => @agent1.id
        assigns(:agent).should eq(@agent1)
        expect(response.status).to eq(200)
      end

      it 'should update agent attributes' do
        put :update, :agent => {:available => false, :display_name => 'Carlos', :engaged => true}, :id => @agent1.id
        @agent1.reload
        @agent1.available.should eq 0
        @agent1.display_name.should eq 'Carlos'
        @agent1.engaged.should eq true
        expect(response.status).to eq(200)
      end

      it 'should not find an agent from another tenant' do
        put :update, :agent => {:available => false}, :id => @agent2.id
        expect(response.status).to eq(404)
      end
    end

    context 'with invalid attributes' do
      it 'should not update an agent with invalid data' do
        put :update, :agent => {:display_name => nil}, :id => @agent1.id
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE :destroy' do
    before {
      @agent1 = create(:agent, :tenant => @tenant1)
      @agent2 = create(:agent, :tenant => @tenant2)
      sign_in @agent1
    }

    it 'should delete the agent' do
      expect {
        delete :destroy, :id => @agent1.id
      }.to change(Agent, :count).by(-1)
    end

    it 'should not delete an agent from another tenant' do
      expect {
        delete :destroy, :id => @agent2.id
      }.to change(Agent, :count).by(0)
    end
  end
end
