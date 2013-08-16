require 'spec_helper'

describe InvitesController do
  include Devise::TestHelpers

  before {
    controller.stub(:authenticate_agent!).and_return true
    @tenant1 = create(:tenant)
  }

  describe 'GET :index' do
    before {
      @invites = (1..3).map { |n| create(:invite, :tenant => @tenant1) }
    }

    it 'gets all invites' do
      get :index
      expect(response.status).to eq(200)
      assigns(:invites).map { |i| i.id }.should eq @invites.map { |i| i.id }
    end
  end

  describe 'GET :show' do
    let (:invites) { (1..3).map { |n| create(:invite, :tenant => @tenant1) } }

    it 'should find and return an invite' do
      get :show, :id => invites[0].id
      expect(response.status).to eq(200)
      assigns(:invite).should eq(invites[0])
    end

    it 'should return a 404 when looking for a nonexistent invite' do
      get :show, :id => 999
      expect(response.status).to eq(404)
    end
  end

  describe 'POST create' do
    before do
      @tenant = create(:tenant)
    end

    context 'with valid attributes' do
      it 'creates an invite' do
        expect {
          post :create, :invite => {:tenant_id => @tenant.id, :recipient_email => "jdoe@gmail.com"}
        }.to change(Invite, :count).by(1)
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid attributes' do
      it 'should not create an invite without a tenant' do
        expect {
          post :create, invite: {:recipient_email => 'jane.doe@gmail.com'}
        }.to change(Invite, :count).by(0)
        expect(response.status).to eq(422)
      end
      it 'should not create an invite without a recipient' do
        expect {
          post :create, invite: {:tenant_id => @tenant.id}
        }.to change(Invite, :count).by(0)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE :destroy' do
    it 'deletes an invite' do
      invite = create(:invite)
      delete :destroy, :id => invite.id
      expect(response.status).to eq(200)
    end

    it 'throws a 404 when trying to delete a nonexistent invite' do
      delete :destroy, :id => 999
      expect(response.status).to eq(404)
    end
  end
end