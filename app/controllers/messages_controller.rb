class MessagesController < ApplicationController
  def create
    unless params[:message][:conversation_id] && !params[:message][:conversation_id].empty?
      customer = Customer.create!({:tenant_id => params[:message][:tenant_id], :display_name => params[:message][:display_name]})
      conversation = Conversation.create!({:tenant_id => params[:message][:tenant_id], :customer_id => customer.id, :active => true, :referer_url => params[:message][:referer_url]})
      params[:message][:conversation_id] = conversation.id
    end

    new_message = Message.create!(message_params)
    if params[:message][:since]
      messages = Message.by_tenant(new_message.tenant_id).by_conversation(new_message.conversation_id).since(params[:message][:since])
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
