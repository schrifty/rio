class MessagesController < ApplicationController
  def create
    new_message = Message.create!(message_params)
    if params[:since]
      messages = Message.by_tenant(new_message.tenant_id).by_conversation(new_message.conversation_id).since(params[:since])
    else
      messages = [ new_message ]
    end
    return render json: messages, status: 201
  end

  def show
    message = Message.find(params[:id])
    return render json: message
  end

  def index
    messages = Message.by_tenant(params[:tenant]).by_conversation(params[:conversation]).since(params[:since])
    return render json: messages
  end

private
  def message_params
    params.require(:message).permit(:tenant_id, :conversation_id, :agent_id, :sent_by, :text)
  end

end
