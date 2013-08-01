require 'spec_helper'

describe TenantsController do
  describe 'POST create' do
    context 'without valid attributes' do
      it 'does not create a tenant when no display name is provided' do
        expect {
          post :create, :tenant => {:twitter_id => 'schrifty', :email => 'marc@gmail.com'}
        }.to change(Tenant, :count).by(0)
        expect(response.status).to eq(422)
      end
    end

    context 'with valid attributes' do
      it 'creates a tenant' do
        expect {
          post :create, :tenant => {:display_name => 'unknown', :twitter_id => 'schrifty', :email => 'marc@gmail.com'}
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

      it 'updates a tenant with invalid data' do
        tenant = create(:tenant)
        put :update, :id => tenant.id, :tenant => {:display_name => nil}
        expect(response.status).to eq(422)
      end

      it 'should not find a nonexistent tenant' do
        get :show, :id => 999
        expect(response.status).to eq(404)
      end
    end
  end
end