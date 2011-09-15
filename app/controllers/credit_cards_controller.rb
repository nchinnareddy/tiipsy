class CreditCardsController < ApplicationController
  
  if ENV['RAILS_ENV'] == "development"
    #ssl_required :show, :new, :create, :edit, :update
  else
    ssl_required :show, :new, :create, :edit, :update
  end
 
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
      render :layout => false 
  end
  # POST /credit_cards
  # POST /credit_cards.xml
  def create
     @creditcard = CreditCard.new(params[:credit_card])
     if !(credit_card(@creditcard).valid?)
       msg = credit_card(@creditcard).errors.full_messages.join('. ')
       flash[:error] = msg  
      #redirect_to new_user_credit_card_path(current_user)
      redirect_to root_path
      return
     end
     if current_user.credit_card
        current_user.credit_card.update_attributes(params[:credit_card])
        flash[:notice] = "Your credit card details are modified"        
     else
        @creditcard.user_id = current_user.id
        flash[:notice] = "Successful added your credit card. Please proceed to Bid or Buy"
        @creditcard.save        
     end
     redirect_to root_path     
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
  
  def edit 
    @credit_card = CreditCard.find(params[:id])
  end
  
  def update
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.update_attributes(params[:credit_card])
      flash[:notice] = "Credit card details updated successful"
      redirect_to  profile_users_path
    else
      flash[:error] = "You have enter worng data"
    end
  end
  
  def destroy
    @creditcard = CreditCard.find(params[:id])
    @creditcard.destroy
    redirect_to  profile_users_path
  end
  
end
