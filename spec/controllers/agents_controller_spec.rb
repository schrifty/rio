require 'spec_helper'

describe AgentsController do
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
        assert_raises ActiveRecord::RecordNotFound do
          get :show, :id => 999
        end
      end
    end

    context 'with invalid attributes' do
      it 'should not create an agent' do
        expect {
          post :create, agent: {:available => true, :engaged => true, :display_name => 'Johnny',
                                   :encrypted_password => 'blech', :xid => 'abc', :admin => true}
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end