class AgentsController < ApplicationController
  def create
    Agent.create!(agent_params)
    return render text: "Created", status: 201
  end

  def update
    agent = Agent.find(params[:id])
    agent.update_attributes!(agent_params)
    return render text: "Successful", status: 200
  end

  def show
    agent = Agent.find(params[:id])
    return render json: agent
  end

  def index
    agents = Agent.all
    return render json: agents
  end

private
  def agent_params
    params.require(:agent).permit(:tenant_id, :available, :engaged, :display_name, :encrypted_password, :xid, :admin)
  end

end
