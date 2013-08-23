class UpdatesController < ApplicationController
  before_filter :authenticate_agent!

  def index
    return render text: "Conversation ID is required", status: 422 unless params[:conversation]

    conversation = Conversation.by_tenant(current_agent.tenant).find(params[:conversation])
    messages = Message.by_tenant(current_agent.tenant).by_conversation(params[:conversation]).since(params[:since])
    agents = Agent.by_tenant(current_agent.tenant).available

    return render json: {:conversation => conversation, :messages => messages, :agents => agents}
  end
end
