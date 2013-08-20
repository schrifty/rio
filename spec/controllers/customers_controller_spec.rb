require 'spec_helper'

describe CustomersController do
  include Devise::TestHelpers

  before {
    controller.stub(:authenticate_agent!).and_return true
    @tenant1 = create(:tenant)
    @tenant2 = create(:tenant)
    @tenant3 = create(:tenant)

    @agent1 = create(:agent, :tenant => @tenant1)

    @customer1 = create(:customer, :tenant => @tenant1)
    @customer2 = create(:customer, :tenant => @tenant2)
    @customers = [@customer1, @customer2] + (1..10).map { |n|
      tenant = [@tenant1, @tenant2, @tenant3][rand(3)]
      create(:customer, :tenant => tenant)
    }

    sign_in @agent1
  }

  describe 'GET :index' do
    it 'should get all accessible customers and only those customers' do
      get :index
      expect(response.status).to eq(200)
      assigns(:customers).map { |c| c.id }.should eq @customers.select { |c| c.tenant == @customer1.tenant }.map { |c| c.id }
    end
  end

  describe 'GET :show' do
    it 'should return one customer' do
      get :show, :id => @customer1.id
      expect(response.status).to eq 200
      assigns(:customer).should eq @customer1
    end

    it 'should return a 404 with a nonexistent customer' do
      get :show, :id => 999
      expect(response.status).to eq(404)
    end

    it 'should not find and return a conversation from another tenant' do
      get :show, :id => @customer2.id
      expect(response.status).to eq 404
    end
  end

  describe 'POST :create' do
    it 'should create a customer' do
      expect {
        post :create, :customer => {:tenant_id => @tenant1.id, :display_name => 'Customer X'}
      }.to change(Customer, :count).by(1)
      expect(response.status).to eq(201)
    end

    it 'should not create a customer with no tenant' do
      expect {
        post :create, customer: {:display_name => 'Customer Y'}
      }.to change(Customer, :count).by(0)
      expect(response.status).to eq(422)
    end

    # TBD - We have to protect create so a tenant can't pollute another tenant's spaces
    #it 'should not create a customer with a forbidden tenant' do
    #  expect {
    #    post :create, customer: {:tenant_id => @tenant2.id, :display_name => 'Customer Z'}
    #  }.to change(Customer, :count).by(0)
    #  expect(response.status).to eq(422)
    #end
  end

  describe 'PUT :update' do
    it 'should find the customer' do
      put :update, :customer => {:display_name => 'Customer Y'}, :id => @customer1.id
      assigns(:customer).should eq @customer1
      expect(response.status).to eq 200
    end

    it 'should update customer attributes' do
      put :update, :customer => {:display_name => 'Customer Z'}, :id => @customer1.id
      @customer1.reload
      @customer1.display_name.should eq 'Customer Z'
    end

    it 'should not update a customer with an empty display_name' do
      put :update, :customer => {:display_name => nil}, :id => @customer1.id
      expect(response.status).to eq 422
    end

    it 'should not update the tenant of a customer' do
      put :update, :customer => {:tenant_id => @tenant2}, :id => @customer1.id
      expect(@customer1.tenant_id).to eq @tenant1.id
    end
  end
end