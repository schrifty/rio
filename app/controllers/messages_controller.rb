class MessagesController < ApplicationController
  def create
    Message.create!(message_params)
    return render text: "Created", status: 201
  end

  def show
    message = Message.find(params[:id])
    return render json: message
  end

  def index
    messages = Message.all
    return render json: messages
  end

private
  def message_params
    params.require(:message).permit(:tenant_id, :conversation_id, :agent_id, :sent_by, :text)
  end

end
