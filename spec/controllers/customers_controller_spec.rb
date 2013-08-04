require 'spec_helper'

describe CustomersController do
  before {
    @tenant1 = create(:tenant)
  }

  describe 'GET :index' do
    before {
      @customers = (1..3).map { |n| create(:customer, :tenant => @tenant1) }
    }

    it 'should return all customers' do
      get :index
      expect(response.status).to eq(200)
      assigns(:customers).map { |c| c.id }.should eq @customers.map { |c| c.id }
    end
  end

  describe 'GET :show' do
    let (:customers) { (1..3).map { |n| create(:customer, :tenant => @tenant1) } }

    it 'should return one customer' do
      get :show, :id => customers[0].id
      expect(response.status).to eq(200)
      assigns(:customer).should eq(customers[0])
    end

    it 'should return a 404 with a nonexistent customer' do
      get :show, :id => 999
      expect(response.status).to eq(404)
    end
  end

  describe 'POST :create' do
    before do
      @tenant = create(:tenant)
    end

    context 'with valid attributes' do
      it 'should create a customer' do
        expect {
          post :create, :customer => {:tenant_id => @tenant.id, :display_name => 'Customer X'}
        }.to change(Customer, :count).by(1)
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid attributes' do
      it 'should not create a customer' do
        expect {
          post :create, customer: {:display_name => 'Customer Z'}
        }.to change(Customer, :count).by(0)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT :update' do
    let (:customer) { create(:customer, :tenant => @tenant1) }

    context 'with valid attributes' do
      it 'should find the customer' do
        put :update, :customer => {:display_name => 'Customer Y'}, :id => customer.id
        assigns(:customer).should eq(customer)
        expect(response.status).to eq(200)
      end

      it 'should update customer attributes' do
        put :update, :customer => {:display_name => 'Customer Y'}, :id => customer.id
        customer.reload
        customer.display_name.should eq 'Customer Y'
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid attributes' do
      it 'should not update a customer' do
        customer = create(:customer)
        put :update, :customer => {:tenant_id => nil}, :id => customer.id
        expect(response.status).to eq(422)
      end
    end
  end

end