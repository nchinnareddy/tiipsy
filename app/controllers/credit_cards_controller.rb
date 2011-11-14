class CreditCardsController < ApplicationController
  #ssl_required :show, :new, :create, :edit, :update
  if ENV['RAILS_ENV'] == "development"
    #ssl_required :show, :new, :create, :edit, :update
  else
    #ssl_required :show, :new, :create, :edit, :update
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
    # @exp_date =  params[:credit_card]["card_expires_on(2i)"] + '/'+ params[:credit_card]["card_expires_on(1i)"] 
     #params["#{card_expires_on.to_s}(1i)"].to_i, params["#{card_expires_on.to_s}(1i)"].to_i, params["#{card_expires_on.to_s}(3i)"].to_i)
    # puts @exp_date
     
     # @yy = Date.new(params["#{credit_card.card_expires_onto_s}(1i)"].to_i,
     #    params["#{field_name.to_s}(2i)"].to_i)
     #      
  result = braintree_customer_create_with_cc(@creditcard)
     if result.success?
       @creditcard.bttoken = result.customer.credit_cards[0].token
       @creditcard.user_id = current_user.id
       @creditcard.save
       puts result.customer.id
       puts result.customer.credit_cards[0].token
       flash[:notice] = "Successful added your credit card. Please proceed to Bid or Buy"
     else
       p result.errors
       flash[:error] = result.errors  
     end
     redirect_to root_path   
     
      
     # if !(credit_card(@creditcard).valid?)
     #        msg = credit_card(@creditcard).errors.full_messages.join('. ')
     #        flash[:error] = msg  
     #       #redirect_to new_user_credit_card_path(current_user)
     #       redirect_to root_path
     #       return
     #      end
     #      if current_user.credit_card
     #         current_user.credit_card.update_attributes(params[:credit_card])
     #         flash[:notice] = "Your credit card details are modified"        
     #      else
     #         @creditcard.user_id = current_user.id
     #         flash[:notice] = "Successful added your credit card. Please proceed to Bid or Buy"
     #         @creditcard.save        
     #      end
     #      redirect_to root_path     
  end

  private
   def braintree_customer_create_with_cc(creditcard)
     @creditcard = creditcard
      result = Braintree::Customer.create(
       :id => current_user.id,
       :first_name => @creditcard.first_name,
       :last_name => @creditcard.last_name,
       :credit_card => {
         :number => @creditcard.card_number,
         :expiration_date => '05/12'
       # :expiration_date => params[:credit_card]["card_expires_on(2i)"] + '/'+ params[:credit_card]["card_expires_on(1i)"],
       #  :cvv => @creditcard.card_verification,
      #   :options => {
      #         :verify_card => true
       #      }
       })
       
        if result.success?
          puts result.customer.id
          puts result.customer.credit_cards[0].token
         else
           result.errors.each do |err|
             puts err
           end
         end
     return result
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
