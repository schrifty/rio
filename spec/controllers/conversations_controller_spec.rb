require 'spec_helper'

describe ConversationsController do
  describe 'POST create' do
    before do
      @tenant = create(:tenant)
      @customer = create(:customer)
    end

    context 'with valid attributes' do
      it 'creates a conversation' do
        expect {
          post :create, :conversation => {:tenant_id => @tenant.id, :customer_id => @customer.id, :active => true, :referer_url => 'http:'}
        }.to change(Conversation, :count).by(1)
        expect(response.status).to eq(201)
      end

      it 'updates an conversation' do
        conversation = create(:conversation)
        put :update, :conversation => {:active => false}, :id => conversation.id
        expect(response.status).to eq(200)
      end

      it 'gets all conversations' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'gets one conversation' do
        conversation = create(:conversation)
        get :show, :id => conversation.id
        expect(response.status).to eq(200)
      end

      it 'should not find a nonexistent conversation' do
        assert_raises ActiveRecord::RecordNotFound do
          get :show, :id => 999
        end
      end
    end

    context 'with invalid attributes' do
      it 'should not create a conversation' do
        expect {
          post :create, conversation: {:customer_id => @customer.id, :active => true, :referer_url => 'http:'}
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end