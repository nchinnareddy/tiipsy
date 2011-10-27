class BidsController < ApplicationController
  
  before_filter :require_user
 #pp - change start
 # before_filter :require_user_with_creditcard
 #pp - change end
  before_filter :require_service_bid_authorized, :except => :complete
  #ssl_required :index, :show, :new, :edit, :create, :update
  if ENV['RAILS_ENV'] == "development"
    #ssl_required :index, :show, :new, :edit, :create, :update
  else
    #ssl_required :index, :show, :new, :edit, :create, :update
  end
    
  def express
    @service = Servicelisting.find(params[:servicelisting_id])
    amount = @service.price
    amount = amount.to_i
    amount = amount * 100

    options = {
        :items => [{ :name => @service.title,:quantity => 1, :description => @service.description, :amount => amount}],
        :ip                => request.remote_ip,
        :return_url        => url_for(:controller => 'bids', :action => 'complete', :id => @service.id),
        :cancel_return_url => servicelistings_url
    }
      #change - pp start 
    response = EXPRESS_GATEWAY.setup_authorization(amount,options
      )

   #  response = EXPRESS_GATEWAY.setup_purchase(amount,
   #     options = {
   #     :items => [
   #     {
   #       :name => @service.title,
   #       :quantity => "1",
   #       :description => @service.description,
   #       :amount => amount
   #      }],
   #     :ip                => request.remote_ip,
   #     :return_url        => url_for(:controller => 'buynow', :action => 'complete', :id => @service.id),
   # #   :return_url        => new_order_url,
   #     :cancel_return_url => servicelistings_url
   #    } )

     #change - pp end 
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
    
    
  # GET /bids
  # GET /bids.xml
  def index
    
    @servicelisting = Servicelisting.find(params[:servicelisting_id])
    
    @bids = @servicelisting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bids }
    end
  end

  # GET /bids/1
  # GET /bids/1.xml
  def show
    @bid = Bid.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bid }
    end
  end

  # GET /bids/new
  # GET /bids/new.xml
  def new
    @servicelisting = Servicelisting.find(params[:servicelisting_id])
    render :layout => false
  end

  # GET /bids/1/edit
  def edit
    @bid = Bid.find(params[:id])
  end

  # POST /bids
  # POST /bids.xml
  def create
    
      @servicelisting = Servicelisting.find(params[:servicelisting_id])
      @product = @servicelisting.title
      @desc = @servicelisting.description
      @bid = @servicelisting.bids.new(params[:bid])
      @servicelisting_id = @servicelisting.id
      @barowner_email = @servicelisting.email
      @second_lowest_bid_details = Bid.where("servicelisting_id=?",@servicelisting_id).last
      unless @second_lowest_bid_details.nil?
        @second_lowest_bid_bidprice = @second_lowest_bid_details.bidprice
        @outbid_price = @bid.bidprice - @second_lowest_bid_bidprice
        @second_lowest_bid_userid = @second_lowest_bid_details.user_id
        @email_details = User.where("id=?",@second_lowest_bid_userid).first
        @email = @email_details.email
      end
      @bid.user_id = current_user.id
      if @bid.bidprice > @servicelisting.highestbid
        @bid.save
        unless @second_lowest_bid_details.nil?
          Notifier.send_mail_to_user_outbid(@email,@outbid_price,@bid.bidprice,@product,@desc).deliver
        end
          Notifier.send_mail_to_user_after_bid(current_user.email,@bid.bidprice,@product,@desc).deliver
          Notifier.send_mail_to_admin_after_bid(@bid.bidprice,@product,@desc).deliver
          Notifier.send_mail_to_barowner_after_bid(@barowner_email,@bid.bidprice,@product,@desc).deliver
          @servicelisting.highestbid = @bid.bidprice
          @servicelisting.save
        else
          flash[:error] = "You must bid up. Your bid failed"
      end
      redirect_to servicelistings_path
  end

  # PUT /bids/1
  # PUT /bids/1.xml
  def update
    @bid = Bid.find(params[:id])

    respond_to do |format|
      if @bid.update_attributes(params[:bid])
        format.html { redirect_to(@bid, :notice => 'Bid was succesfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bids/1
  # DELETE /bids/1.xml
  def destroy
    @bid = Bid.find(params[:id])
    @bid.destroy

    respond_to do |format|
      format.html { redirect_to(bids_url) }
      format.xml  { head :ok }
    end
  end 
  
  def complete
    @order = current_user.orders.new(:express_token => params[:token] , :express_payer_id => params[:PayerID])
    @service = Servicelisting.find(params[:id])
    #change - pp  start 
    details_response = OrderTransaction.xpressgateway.details_for(params[:token])
    #details_response = EXPRESS_GATEWAY.details_for(params[:token])
     #change - pp end 

       if details_response.success?
         @orders = Order.where("user_id = ? AND servicelisting_id = ? AND state = ? ", current_user.id, params[:id], 'authorized')
         @orders.each do |orderx|
            orderx.express_token = params[:token]
            orderx.express_payer_id = params[:PayerID]
            @servicelisting = Servicelisting.find(params[:id])
            if orderx.save
              if orderx.authorize_payment
                flash[:notice] = "You are authorized to bid on: #{@service.title}"
                redirect_to root_path
              else
                flash[:notice] = "Sorry - The details you entered might be in-corrrect. We are unable to process your transaction. Re-enter your credit card details"
                #redirect_to new_user_credit_card_path(current_user)
                redirect_to root_path
              end
            end
          end  
       else 
           @message = details_response.message
           render :text => 'error'
           return
       end

    #  @address = details_response.address
    #  @amount = 111
    #  @amount = current_user.pendingpay
    #raise @order.to_yaml

  end
  
end
