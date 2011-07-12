class AuthLinkedinController < ApplicationController
  
  def index
    # get your api keys at https://www.linkedin.com/secure/developer
    client = LinkedIn::Client.new('G86PSxa_4MWCCnterDua4LPf4gIfSWpP7IU7W0XPf_JTNlHYQKS1I45rtCCdEo1b', 'IS125GA-O2FZzxFw7v1Ovd4Azrn_hRsXcXheWoZMP31BnG1vUCYt4rh03XAJGV-J')
    request_token = client.request_token(:oauth_callback => "http://#{request.host_with_port}/auth_linkedin/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret
    redirect_to client.request_token.authorize_url
  end

  def callback
    client = LinkedIn::Client.new('G86PSxa_4MWCCnterDua4LPf4gIfSWpP7IU7W0XPf_JTNlHYQKS1I45rtCCdEo1b', 'IS125GA-O2FZzxFw7v1Ovd4Azrn_hRsXcXheWoZMP31BnG1vUCYt4rh03XAJGV-J')
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @client = client
    @profile = client.profile(:fields => [:first_name, :last_name, :summary, :connections, :industry, :picture_url, :site_standard_profile_request])
    @connections = client.connections
    
  end

end
