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
     if current_user.credit_card
       redirect_to edit_user_credit_card_path(current_user.credit_card)
       return
     end
      @credit_card = CreditCard.new
  end

  # GET /credit_cards/1/edit
  def edit
    @credit_card = CreditCard.find(params[:id])
  end

  # POST /credit_cards
  # POST /credit_cards.xml
  def create
     @creditcard = CreditCard.new(params[:credit_card])
     if !(credit_card(@creditcard).valid?)
      flash[:error] = "Your card is not valid"   
      redirect_to new_user_credit_card_path(current_user)
      return
     end

     if current_user.credit_card
      if current_user.credit_card.update_attributes(params[:credit_card])
         flash[:notice] = "Your credit card details are modified"
      else
        @creditcard = CreditCard.new(params[:credit_card])
        @creditcard.user_id = current_user.id
    
  
   if current_user.credit_card
    current_user.credit_card = @creditcard
    current_user.credit_card.save
    flash[:notice] = "Your credit card details are modified"
   else
    @creditcard.save
    flash[:notice] = "Your credit card details are on file"
   end
  
   redirect_to root_path(current_user)
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
