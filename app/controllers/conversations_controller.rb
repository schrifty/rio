class ConversationsController < ApplicationController
  def create
    begin
      conversations = [ Conversation.create!(conversation_params) ]
      return render json: conversations, status: 201
    rescue ActiveRecord::RecordInvalid => e
      return render text: e.message, status: 422
    end
  end

  def update
    begin
      conversation = Conversation.find(params[:id])
      conversation.update_attributes!(conversation_params)
      return render json: conversation, status: 200
    rescue ActiveRecord::RecordInvalid => e
      return render text: e.message, status: 422
    end
  end

  def show
    begin
      conversation = Conversation.find(params[:id])
      return render json: conversation
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def new
  end

  def index
    conversations = Conversation.all
    return render json: conversations
  end

private
  def conversation_params
    params.require(:conversation).permit(:tenant_id, :active, :customer_id, :referer_url, :location, :customer_data, :first_customer_message, :engaged_agent_id, :preferred_response_channel, :preferred_response_channel_info)
  end

end
