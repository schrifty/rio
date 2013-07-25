require 'spec_helper'

describe InvitesController do
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

      it 'deletes an invite' do
        invite = create(:invite)
        delete :destroy, :id => invite.id
        expect(response.status).to eq(200)
      end

      it 'throws a 404 when trying to delete a nonexistent invite' do
        assert_raises ActiveRecord::RecordNotFound do
          delete :destroy, :id => 999
        end
      end

      it 'gets all invites' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'gets one invite' do
        invite = create(:invite)
        get :show, :id => invite.id
        expect(response.status).to eq(200)
      end

      it 'should not find a nonexistent invite' do
        assert_raises ActiveRecord::RecordNotFound do
          get :show, :id => 999
        end
      end
    end

    context 'with invalid attributes' do
      it 'should not create an invite' do
        expect {
          post :create, invite: {:recipient_email => 'jane.doe@gmail.com'}
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end