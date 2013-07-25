require 'spec_helper'

describe CustomersController do
  describe 'POST create' do
    before do
      @tenant = create(:tenant)
    end

    context 'with valid attributes' do
      it 'creates a customer' do
        expect {
          post :create, :customer => {:tenant_id => @tenant.id, :display_name => 'Customer X'}
        }.to change(Customer, :count).by(1)
        expect(response.status).to eq(201)
      end

      it 'updates a customer' do
        customer = create(:customer)
        put :update, :customer => {:display_name => 'Customer Y'}, :id => customer.id
        expect(response.status).to eq(200)
      end

      it 'gets all customers' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'gets one customer' do
        customer = create(:customer)
        get :show, :id => customer.id
        expect(response.status).to eq(200)
      end

      it 'should not find a nonexistent customer' do
        assert_raises ActiveRecord::RecordNotFound do
          get :show, :id => 999
        end
      end
    end

    context 'with invalid attributes' do
      it 'should not create a customer' do
        expect {
          post :create, customer: {:display_name => 'Customer Z'}
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end