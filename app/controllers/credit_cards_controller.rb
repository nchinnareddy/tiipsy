class CreditCardsController < ApplicationController

  #ssl_required :show, :new, :create, :edit, :update
  if ENV['RAILS_ENV'] == "development"
    #ssl_required :show, :new, :create, :edit, :update
  else
    #ssl_required :show, :new, :create, :edit, :update
  end

  def show
    @credit_card = CreditCard.find(params[:id])
   
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @credit_card }
    end
  end

  def new
      @credit_card = CreditCard.new
      render :layout => false 
  end

#TODO
=begin
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
       #flash[:error] = result.errors  
       flash[:error] = "Your Credit Card details entered are incorrect. Please re-enter"
     end
     redirect_to servicelistings_path   
     
      
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
=end

  def create

    @credit_card = current_user.credit_cards.first
    if @credit_card.nil?
      @credit_card = CreditCard.new(params[:credit_card])

      result = Braintree::Customer.create(
                :id => current_user.id,
                :first_name => @credit_card.first_name,
                :last_name => @credit_card.last_name,
                :credit_card => {
                  :number => @credit_card.card_number,
                  :expiration_date => @credit_card.card_expires_on.strftime("%m/%y"),
                  :options => {
                    :make_default => true
                  }
                }
               )

      if result.success?
        puts result.customer.id
        puts result.customer.credit_cards[0].token
        @credit_card.bttoken = result.customer.credit_cards[0].token
        @credit_card.user_id = current_user.id
        @credit_card.save
        flash[:notice] = "Successful added your credit card. Please proceed to Bid or Buy"
      else
        p result.errors
        flash[:error] = "Your Credit Card details entered are incorrect. Please re-enter"
      end
    else
      @credit_card = CreditCard.new(params[:credit_card])
      result = Braintree::Customer.update(
        current_user.id,
        :first_name => @credit_card.first_name,
        :last_name => @credit_card.last_name,
        :credit_card => {
          :number => @credit_card.card_number,
          :expiration_date => @credit_card.card_expires_on.strftime("%m/%y"),
          :options => {
            :make_default => @credit_card.default_card
          }
        }
      )

      if result.success?
        @credit_card.bttoken = result.customer.credit_cards[0].token
        @credit_card.user_id = current_user.id
        @credit_card.save
        flash[:notice] = "Successful added your credit card. Please proceed to Bid or Buy"
      else
        p result.errors
        flash[:error] = "Your Credit Card details entered are incorrect. Please re-enter"
      end
    end

    redirect_to servicelistings_path
  end

  def edit
    @credit_card = CreditCard.find(params[:id])
    render :layout => false
  end

  def update
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.update_attributes(params[:credit_card])
      result = Braintree::Customer.update(
        current_user.id,
        :first_name => @credit_card.first_name,
        :last_name => @credit_card.last_name,
        :credit_card => {
          :number => @credit_card.card_number,
          :expiration_date => @credit_card.card_expires_on.strftime("%m/%y"),
          :options => {
             # token of credit card to update
             :update_existing_token => @credit_card.bttoken,
             :make_default => @credit_card.default_card
          }
        }
      )

      if result.success?
        if @credit_card.default_card
          reset_default_card(@credit_card.id)
        end
        flash[:notice] = "Credit card details updated successful"
      else
        p result.errors
      end

    else
      flash[:error] = "You have enter wrong data"
    end

    redirect_to  account_users_path(:anchor => "tab3")
  end

  def destroy
    begin
      @credit_card = CreditCard.find(params[:id])
      Braintree::CreditCard.delete(@credit_card.bttoken)
      @credit_card.destroy

      flash[:notice] = "Deleted credit card details successfully."
    rescue
      flash[:error] = "Unable to delete credit card details. Please try again."
    end

    redirect_to  account_users_path(:anchor => "tab3")
  end

  def make_default
    begin
      @credit_card = CreditCard.find(params[:id])
      result = Braintree::CreditCard.update(
        @credit_card.bttoken,
        :number => @credit_card.card_number,
        :expiration_date => @credit_card.card_expires_on.strftime("%m/%y"),
        :options => {
          :make_default => true
        }
      )

      reset_default_card(@credit_card.id)

      if result.success?
        flash[:notice] = "Updated default card successfully."

      else
        p result.errors
      end

    rescue
      flash[:error] = "Unable to make card as default failed. Please try again."
    end

    redirect_to  account_users_path(:anchor => "tab3")
  end

  private

  def reset_default_card(credit_card_id)
    current_user.credit_cards.update_all(:default_card => 0)
    current_user.credit_cards.update(credit_card_id, :default_card => 1)
  end

=begin
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
  

  

  
  def destroy
    @creditcard = CreditCard.find(params[:id])
    @creditcard.destroy
    redirect_to  profile_users_path
  end
=end
end