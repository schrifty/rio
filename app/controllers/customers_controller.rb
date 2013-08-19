class CustomersController < ApplicationController
  before_filter :authenticate_agent!

  def create
    Customer.transaction do
      begin
        @customer = Customer.create!(customer_params)
        return render json: @customer, status: 201
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
    Customer.transaction do
      begin
        @customer = Customer.by_tenant(current_agent.tenant).find(params[:id])
        @customer.update!(update_params)
        return render json: @customer, status: 200
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
      @customer = Customer.by_tenant(current_agent.tenant).find(params[:id])
      return render json: @customer
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def index
    @customers = Customer.by_tenant(current_agent.tenant).all
    return render json: @customers
  end

  private
  def customer_params
    params.require(:customer).permit(:tenant_id, :display_name)
  end

  def update_params
    params.require(:customer).permit(:display_name)
  end
end
