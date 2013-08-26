class MessagesController < ApplicationController
  before_filter :authenticate_agent!

  def create
    Message.transaction do
      begin
        unless params[:message][:conversation_id] && !params[:message][:conversation_id].empty?
          display_name = params[:message][:display_name] || "Unknown"
          customer = Customer.create!({:tenant_id => params[:message][:tenant_id], :display_name => display_name})
          conversation = Conversation.create!({:tenant_id => params[:message][:tenant_id], :customer_id => customer.id, :resolved => false, :referer_url => params[:message][:referer_url]})
          params[:message][:conversation_id] = conversation.id
        end

        new_message = Message.create!(message_params)
        if params[:message][:since]
          @messages = Message.by_tenant(new_message.tenant_id).by_conversation(new_message.conversation_id).since(params[:message][:since])
        else
          @messages = [new_message]
        end
        return render json: @messages, status: 201
      rescue ActiveRecord::RecordInvalid => e
        render text: e.message, status: 422
        raise ActiveRecord::Rollback
      rescue Exception => e
        render text: e.message, status: 500
        raise ActiveRecord::Rollback
      end
    end
  end

  def show
    begin
      @message = Message.by_tenant(current_agent.tenant).find(params[:id])
      return render json: @message
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def index
    opts = {}
    opts.reverse_merge({:order => 'created_at desc', :limit => params[:limit]}) if params[:limit] && params[:limit].to_i != -1
    @messages = Message.by_tenant(current_agent.tenant).by_conversation(params[:conversation]).since(params[:since]).order('created_at desc')
    if params[:limit].to_i > 0
      @messages = @messages.limit(params[:limit].to_i)
    end

    return render json: @messages,
      :methods => [:author_display_name, :author_role]
  end

  def message_params
    params.require(:message).permit(:tenant_id, :conversation_id, :agent_id, :sent_by, :text)
  end

end
