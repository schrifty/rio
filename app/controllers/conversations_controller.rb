class ConversationsController < ApplicationController
  before_filter :authenticate_agent!
  respond_to :json
  respond_to :html, :only => [:search]

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
    @conversations = Conversation.by_tenant(current_agent.tenant).unresolved
    respond_with(@conversations, :methods => [:customer_display_name, :last_message_author_role,
                              :last_message_author_display_name, :last_message_created_at,
                              :last_message_text, :engaged_agent_name, :message_count])
  end

  def search
    if params[:q]
      q = "text:#{params[:q]}"
      s = Tire.search('messages', {}) { query { string q + '*' } }
      conv_ids = s.results.collect{|d| d.conversation_id}.uniq
      @search_results = Conversation.by_tenant(current_agent.tenant).by_id(conv_ids).order("field(id, #{conv_ids.join(',')})")
      first = last = nil
      @search_results.each{|conv|
        conv.messages.each_with_index{|msg, i|
          if /(#{params[:q]}\S*)/.match(msg.text)
            first = i unless first
            last = i
            msg.text = msg.text.gsub($1, "<span class='search-term'>#{$1}</span>")
          end
        }
        conv.messages = conv.messages.slice!([first - 1, 0].max..[last + 1, conv.messages.size - 1].min)
      }
    end
    respond_to do |format|
      format.json { render json: @search_results}
      format.html { render :partial => "search_results" }
    end
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
