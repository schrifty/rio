class CustomersController < ApplicationController
  def create
    Customer.create!(customer_params)
    return render text: "Created", status: 201
  end

  def update
    customer = Customer.find(params[:id])
    customer.update_attributes!(customer_params)
    return render text: "Successful", status: 200
  end

  def show
    customer = Customer.find(params[:id])
    return render json: customer
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
