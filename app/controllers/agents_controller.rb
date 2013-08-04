class AgentsController < ApplicationController
  def create
    Agent.transaction do
      begin
        @agent = Agent.create!(agent_params)
        return render json: [ @agent ], status: 201
      rescue ActiveRecord::RecordInvalid => e
        render text: e.message, status: 422
        raise ActiveRecord::Rollback
      rescue Exception => e
        render text: e.message, status: 500
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
    @agent = Agent.find(params[:id])
    begin
      @agent.update_attributes!(agent_params)
      return render json: @agent, status: 200
    rescue ActiveRecord::RecordInvalid => e
      return render text: e.message, status: 422
    end
  end

  def show
    begin
      @agent = Agent.find(params[:id])
      if request.head?
        return render status: 200
      else
        return render json: @agent
      end
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def index
    if params[:email]
      @agents = Agent.by_email(params[:email])
      if request.head? && @agents.empty?
        return render status: 404
      end
    else
      @agents = Agent.all
    end
    return render json: @agents
  end

  def destroy
    begin
      @agent = Agent.find(params[:id])
      @agent.destroy
      return render json: @agent, status: 200
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end
private
  def agent_params
    params.require(:agent).permit(:tenant_id, :email, :available, :engaged, :display_name, :password, :xid, :admin)
  end

end
