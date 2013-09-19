class TenantsController < ApplicationController
  before_filter :authenticate_agent!, :except => [:new]

  def create
    begin
      @tenant = Tenant.create!(tenant_params)
      return render json: [@tenant], status: 201
    rescue ActiveRecord::RecordInvalid => e
      return render text: e.message, status: 422
    end
  end

  def update
    begin
      @tenant = Tenant.find(params[:id])
      @tenant.update_attributes!(tenant_params)
      return render json: @tenant, status: 200
    rescue ActiveRecord::RecordInvalid => e
      return render text: e.message, status: 422
    end
  end

  def show
    begin
      @tenant = Tenant.find(params[:id])
      return render json: @tenant
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def index
    @tenants = Tenant.all
    return render json: @tenants
  end

  def new
    @search_results = []
    @conversations = []
    if current_agent
      @conversations = Conversation.by_tenant(current_agent.tenant).unresolved.includes(:messages).order('conversations.updated_at desc')
    end
  end

  private
  def tenant_params
    params.require(:tenant).permit(:twitter_id, :email, :display_name, :demo_mode)
  end
end
