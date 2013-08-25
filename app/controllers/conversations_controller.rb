class ConversationsController < ApplicationController
  before_filter :authenticate_agent!
  respond_to :json

  def create
    Conversation.transaction do
      begin
        @conversations = [Conversation.create!(create_params)]
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

  # main use case is the poller - tenant wants to see all unresolved conversations (i.e. resolved == false)
  def index
    respond_with(@conversations = Conversation.by_tenant(current_agent.tenant).unresolved,
      :methods => [:customer_display_name, :last_message, :last_message_author_display_name, :last_message_created_at, :message_count])
  end

  private
  def create_params
    params.require(:conversation).permit(:tenant_id, :resolved, :customer_id, :referer_url, :location, :customer_data,
                                         :first_message_id, :last_message_id, :engaged_agent_id, :target_agent_id,
                                         :preferred_response_channel, :preferred_response_channel_info)
  end

  def update_params
    params.require(:conversation).permit(:resolved, :referer_url, :location, :customer_data,
                                         :first_message_id, :last_message_id, :engaged_agent_id, :target_agent_id,
                                         :preferred_response_channel, :preferred_response_channel_info)
  end
end
