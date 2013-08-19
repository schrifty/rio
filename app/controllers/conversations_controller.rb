class ConversationsController < ApplicationController
  before_filter :authenticate_agent!

  def create
    Conversation.transaction do
      begin
        @conversations = [Conversation.create!(conversation_params)]
        return render json: @conversations, status: 201
      rescue ActiveRecord::RecordInvalid => e
        return render text: e.message, status: 422
        raise ActiveRecord::Rollback
      rescue Exception => e
        render text: e.message, status: 500
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
    Conversation.transaction do
      begin
        @conversation = Conversation.by_tenant(current_agent.tenant).find(params[:id])
        @conversation.update!(update_params)
        return render json: @conversation, status: 200
      rescue ActiveRecord::RecordInvalid => e
        render text: e.message, status: 422
        raise ActiveRecord::Rollback
      rescue Exception => e
        render text: e.message, status: 403
        raise ActiveRecord::Rollback
      end
    end
  end

  def show
    begin
      @conversation = Conversation.by_tenant(current_agent.tenant).find(params[:id])
      if request.head?
        return render status: 200
      else
        return render json: @conversation
      end
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def new
  end

  def index
    @conversations = Conversation.by_tenant(current_agent.tenant)
    return render json: @conversations
  end

  private
  def conversation_params
    params.require(:conversation).permit(:tenant_id, :active, :customer_id, :referer_url, :location, :customer_data,
                                         :first_customer_message, :engaged_agent_id, :target_agent_id,
                                         :preferred_response_channel, :preferred_response_channel_info)
  end

  def update_params
    params.require(:conversation).permit(:active, :referer_url, :location, :customer_data,
                                         :first_customer_message, :engaged_agent_id, :target_agent_id,
                                         :preferred_response_channel, :preferred_response_channel_info)
  end
end
