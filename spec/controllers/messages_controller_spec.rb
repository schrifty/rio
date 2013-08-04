require 'spec_helper'

describe MessagesController do
  before {
    @tenant1 = create(:tenant)
    @conversation1 = create(:conversation)
  }

  describe 'GET :index' do
    before {
      @messages = (1..3).map { |n| create(:message, :tenant => @tenant1, :conversation => @conversation1) }
    }

    it 'should return all messages' do
      get :index
      expect(response.status).to eq(200)
      assigns(:messages).map { |a| a.id }.should eq @messages.map { |a| a.id }
    end
  end

  describe 'GET :show' do
    let (:messages) { (1..3).map { |n| create(:message, :tenant => @tenant1, :conversation => @conversation1) } }

    it 'should find and return one message' do
      get :show, :id => messages[0].id
      expect(response.status).to eq(200)
      assigns(:message).should eq(messages[0])
    end

    it 'should not find a nonexistent message' do
      get :show, :id => 999
      expect(response.status).to eq(404)
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      it 'should create a new message' do
        expect {
          post :create, :message => {:tenant_id => @tenant1.id, :conversation_id => create(:conversation).id, :agent_id => create(:agent).id,
                                     :sent_by => 'twitter', :text => 'This is the message'}
        }.to change(Message, :count).by(1)
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid attributes' do
      it 'should not create a message' do
        expect {
          post :create, message: {:conversation_id => create(:conversation).id, :agent_id => create(:agent).id, :sent_by => 'twitter',
                                  :text => 'This is the message'}
        }.to change(Message, :count).by(0)
        expect(response.status).to eq(422)
      end
    end
  end
end