class TenantsController < ApplicationController
  def create
    Tenant.create!(tenant_params)
    return render text: "Created", status: 201
  end

  def update
    tenant = Tenant.find(params[:id])
    tenant.update_attributes!(tenant_params)
    return render text: "Successful", status: 200
  end

  def show
    tenant = Tenant.find(params[:id])
    return render json: tenant
  end

  def index
    tenants = Tenant.all
    return render json: tenants
  end

  private
    def tenant_params
      params.require(:tenant).permit(:twitter_id, :email)
    end
end
