require 'spec_helper'

describe TenantsController do
  describe 'POST create' do
    context 'with valid attributes' do
      it 'creates a tenant' do
        expect {
          post :create, :tenant => {:twitter_id => 'schrifty', :email => 'marc@gmail.com'}
        }.to change(Tenant, :count).by(1)
        expect(response.status).to eq(201)
      end

      it 'gets all tenants' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'gets one tenant' do
        tenant = create(:tenant)
        get :show, :id => tenant.id
        expect(response.status).to eq(200)
      end

      it 'updates a tenant' do
        tenant = create(:tenant)
        put :update, :id => tenant.id, :tenant => {:twitter_id => 'schrifty'}
        expect(response.status).to eq(200)
      end

      it 'should not find a nonexistent tenant' do
        assert_raises ActiveRecord::RecordNotFound do
          get :show, :id => 999
        end
      end
    end
  end
end