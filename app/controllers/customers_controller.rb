class CustomersController < ApplicationController
  def create
    begin
      customer = Customer.create!(customer_params)
      return render json: [customer], status: 201
    rescue ActiveRecord::RecordInvalid => e
      return render text: e.message, status: 422
    end
  end

  def update
    begin
      customer = Customer.find(params[:id])
      customer.update_attributes!(customer_params)
      return render json: customer, status: 200
    rescue ActiveRecord::RecordInvalid => e
      return render text: e.message, status: 422
    end
  end

  def show
    begin
      customer = Customer.find(params[:id])
      return render json: customer
    rescue ActiveRecord::RecordNotFound => e
      return render text: e.message, status: 404
    end
  end

  def index
    customers = Customer.all
    return render json: customers
  end

  private
  def customer_params
    params.require(:customer).permit(:tenant_id, :display_name)
  end

end
