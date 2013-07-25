require 'spec_helper'

describe MessagesController do
  describe 'POST create' do
    before do
      @tenant = create(:tenant)
    end

    context 'with valid attributes' do
      it 'creates a message' do
        expect {
          post :create, :message => {:tenant_id => @tenant.id, :conversation_id => create(:conversation).id, :agent_id => create(:agent).id,
                                     :sent_by => 'twitter', :text => 'This is the message'}
        }.to change(Message, :count).by(1)
        expect(response.status).to eq(201)
      end

      it 'gets all messages' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'gets one message' do
        message = create(:message)
        get :show, :id => message.id
        expect(response.status).to eq(200)
      end

      it 'should not find a nonexistent message' do
        assert_raises ActiveRecord::RecordNotFound do
          get :show, :id => 999
        end
      end
    end

    context 'with invalid attributes' do
      it 'should not create a message' do
        expect {
          post :create, message: {:conversation => create(:conversation), :agent => create(:agent), :sent_by => 'twitter',
                                  :text => 'This is the message'}
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end