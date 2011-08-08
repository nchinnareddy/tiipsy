class CreditCardsController < ApplicationController
 
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
  end

  # GET /credit_cards/1/edit
  def edit
    @credit_card = CreditCard.find(params[:id])
  end

  # POST /credit_cards
  # POST /credit_cards.xml
  def create
    mycredit_card = CreditCard.new(params[:credit_card])
    mycredit_card.user_id = current_user.id
    
    if !credit_card(mycredit_card).valid?
      flash[:error] = "Your card is not valid"   
      redirect_to servicelistings_path
      return
    end
     if mycredit_card.save
         @authorder =  Order.create(:amount => 100,
                        :description => "Authorization",
                        :ip_address => request.remote_ip,
                        :first_name => mycredit_card.first_name,
                        :last_name => mycredit_card.last_name,
                        :card_type => mycredit_card.card_type,
                        :card_number => mycredit_card.card_number,
                        :card_verification => mycredit_card.card_verification,
                        :card_expires_on => mycredit_card.card_expires_on,
                        :address => mycredit_card.address,
                        :city => mycredit_card.city,
                        :state_name => mycredit_card.state_name,
                        :country => mycredit_card.country,
                        :zip => mycredit_card.zip
                       )
       if @authorder.authorize_payment
         current_user.bid_authorized = true
         current_user.save
         redirect_to servicelistings_path, :notice => "You are authorized to bid now"
         return
       else
        flash[:error] = "Your card is not authorized. there is some problem"
        redirect_to servicelistings_path
       end
     end   
  end

  
def credit_card(cc)
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => cc.card_type,
      :number             => cc.card_number,
      :verification_value => cc.card_verification,
      :month              => cc.card_expires_on.month,
      :year               => cc.card_expires_on.year,
      :first_name         => cc.first_name,
      :last_name          => cc.last_name
    )
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
  
  def term_condiation
    render :layout=>false
  end
  
end
