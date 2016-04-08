class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /orders
  # GET /orders.json
  def sales
    @orders = Order.where(seller: current_user.id).order("created_at DESC")
  end 

  def purchases
    @orders = Order.where(buyer: current_user.id).order("created_at DESC")
  end 


  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @service = Service.find(params[:service_id])
  end

  # GET /orders/1/edit  
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @service = Service.find(params[:service_id])
    @seller = @service.userID

    @order.service_id = @service.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller

    PinPayment.secret_key = 'CRuWFFtjN2m3djtcNB439A'
    card_token = params[:card_token]
    number = params[:number]
    name = params[:name]
    expiry_year = params[:expiry_year]
    expiry_month = params[:expiry_month]
    cvc = params[:cvc]

    charge = PinPayment::Charge.create(
          email:       current_user.email,
          description: @service.description,
          amount:      (@service.price * 100).floor,
          currency:    'AUD',
          ip_address:  request.remote_ip,
          card:        {
            number:           number,
            expiry_month:     expiry_month,
            expiry_year:      expiry_year,
            cvc:              cvc,
            name:             current_user.name,
          }
          )   

    if charge.success?
    alert ("yo success")
    end


    respond_to do |format|
      if @order.save
        format.html { redirect_to root_url, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address, :city, :state)
    end
end
