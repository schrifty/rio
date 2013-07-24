class UpdatesController < ApplicationController
  def index
    return render text: "Conversation ID is required", status: 422 unless params[:conversation]

    conversation = Conversation.find(params[:conversation])
    messages = Message.by_tenant(params[:tenant]).by_conversation(params[:conversation]).since(params[:since])
    agents = Agent.by_tenant(conversation.tenant).available

    return render json: {:conversation => conversation, :messages => messages, :agents => agents}
  end
end
