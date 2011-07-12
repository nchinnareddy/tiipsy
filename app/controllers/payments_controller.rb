class PaymentsController < ApplicationController
  include ActiveMerchant::Billing
  
  def index
  end

  def confirm
    redirect_to :action => 'index' unless params[:token]
  
    details_response = mygateway.details_for(params[:token])
  
     if !details_response.success?
      @message = details_response.message
      render :text => 'error'
      return
     end
    
    @address = details_response.address
  end

  def complete
  purchase = mygateway.purchase(5000,
    :ip       => request.remote_ip,
    :payer_id => params[:payer_id],
    :token    => params[:token]
  )
  
  if !purchase.success?
    @message = purchase.message
    render :text => 'error'
    return
  end
end


def checkout
   setup_response = mygateway.setup_purchase(5000,
   :ip                => request.remote_ip,
   :return_url        => url_for(:action => 'confirm', :only_path => false),
   :cancel_return_url => url_for(:action => 'index', :only_path => false)
  )
  redirect_to gateway.redirect_url_for(setup_response.token)
end


private
def mygateway
  @paygateway ||= PaypalExpressGateway.new(
    :login => 'nchinn_1307094132_biz_api1.gmail.com',
    :password => '1307094143',
    :signature => 'A3tSrUJhWQkOjSs.LnbMRFOlOFN3AdRRcOCmTIWXkXK8x5Pn4e93CiVB'
  )
end

end
