class SubscribersController < ApplicationController
  
  EMAIL_REGEX = /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  after_action :verify_policy_scoped, only: %i[]
  after_action :verify_authorized, except: %i[new create]
  respond_to :html

  def new
  end

  def create
    if params['NAME'].present? && params['EMAIL'].present? && params['EMAIL'] =~ EMAIL_REGEX
      mailchimp = Gibbon::API.new
      begin
        mailchimp.lists.subscribe({id: params[:id], email: {email: params['EMAIL']}, merge_vars: {:NAME => params['NAME']}, double_optin: false})
      rescue => e
        flash[:alert] = e.message
        return render action: :new
      end    
    else
      flash[:alert] = "Você precisa informar seu nome e seu email para participar."
      return render action: :new
    end
  end

end
