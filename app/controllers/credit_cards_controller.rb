class CreditCardsController < ApplicationController
  # GET /credit_cards
  # GET /credit_cards.xml
#  def index
#    @credit_cards = CreditCard.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @credit_cards }
#    end
#  end

  # GET /credit_cards/1
  # GET /credit_cards/1.xml
  def show
    @credit_card = CreditCard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @credit_card }
    end
  end

  # GET /credit_cards/new
  # GET /credit_cards/new.xml
  def new
    @credit_card = CreditCard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @credit_card }
    end
  end

  # GET /credit_cards/1/edit
  def edit
    @credit_card = CreditCard.find(params[:id])
  end

  # POST /credit_cards
  # POST /credit_cards.xml
  def create
    @credit_card = CreditCard.new(params[:credit_card])
    @credit_card.user_id = current_user.id
        
     if @credit_card.save
         @authorder =  Order.create(:amount => 100,
                        :description => "Authorization",
                        :first_name => @credit_card.first_name,
                        :last_name => @credit_card.last_name,
                        :card_type => @credit_card.card_type,
                        :card_number => @credit_card.card_number,
                        :card_verification => @credit_card.card_verification,
                        :card_expires_on => @credit_card.card_expires_on,
                        :address => @credit_card.address,
                        :city => @credit_card.city,
                        :state_name => @credit_card.state_name,
                        :country => @credit_card.country,
                        :zip => @credit_card.zip
                       )  
       if @authorder.authorize_payment({ :ip => request.remote_ip,
                          :billing_address => {
                          :name     => @credit_card.first_name + @credit_card.last_name,
                          :address1 => @credit_card.address,
                          :city     => @credit_card.city,
                          :state    => @credit_card.state_name,
                          :country  => @credit_card.country,
                          :zip      => @credit_card.zip
                          }
                         }
                        )
        current_user.bid_authorized = true
        current_user.save
         render :text => "You are authorized to bid now"
       else
         render :text => "Your card is not authorized. there is some problem"
       end
     end   
  end

  # PUT /credit_cards/1
  # PUT /credit_cards/1.xml
  def update
    @credit_card = CreditCard.find(params[:id])

    respond_to do |format|
      if @credit_card.update_attributes(params[:credit_card])
        format.html { redirect_to(@credit_card, :notice => 'Credit card was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @credit_card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_cards/1
  # DELETE /credit_cards/1.xml
  def destroy
    @credit_card = CreditCard.find(params[:id])
    @credit_card.destroy

    respond_to do |format|
      format.html { redirect_to(credit_cards_url) }
      format.xml  { head :ok }
    end
  end
end
