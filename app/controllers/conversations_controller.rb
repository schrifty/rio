class ConversationsController < ApplicationController
  def create
    conversations = [ Conversation.create!(conversation_params) ]
    return render json: conversations, status: 201
  end

  def update
    conversation = Conversation.find(params[:id])
    conversation.update_attributes!(conversation_params)
    return render text: "Successful", status: 200
  end

  def show
    conversation = Conversation.find(params[:id])
    return render json: conversation
  end

  def new
  end

  def index
    conversations = Conversation.all
    return render json: conversations
  end

private
  def conversation_params
    params.require(:conversation).permit(:tenant_id, :active, :customer_id, :referer_url, :location, :customer_data, :first_customer_message, :engaged_agent, :preferred_response_channel, :preferred_response_channel_info)
  end

end
