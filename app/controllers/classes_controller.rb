class ClassesController < ApplicationController
  
  after_action :verify_policy_scoped, only: %i[]
  after_action :verify_authorized, except: %i[index meme]
  respond_to :html

  def index
  end

  def meme
  end

end
