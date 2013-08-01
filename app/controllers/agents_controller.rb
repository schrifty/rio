class AgentsController < ApplicationController
  def create
    Agent.transaction do
      begin
        unless params[:agent][:tenant_id] && !params[:agent][:tenant_id].empty?
          display_name = params[:agent][:email]
          tenant = Tenant.create({:display_name => display_name})
          params[:agent][:tenant_id] = tenant.id
        end

        agent = Agent.create!(agent_params)
        return render json: [ agent ], status: 201
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
    agent = Agent.find(params[:id])
    begin
      agent.update_attributes!(agent_params)
      return render json: agent, status: 200
    rescue ActiveRecord::RecordInvalid => e
      return render text: e.message, status: 422
    end
  end

  def show
    begin
      agent = Agent.find(params[:id])
      return render json: agent
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def index
    agents = Agent.all
    return render json: agents
  end

private
  def agent_params
    params.require(:agent).permit(:tenant_id, :email, :available, :engaged, :display_name, :encrypted_password, :xid, :admin)
  end

end
