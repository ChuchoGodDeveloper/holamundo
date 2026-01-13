class SessionsController < ApplicationController
  def new
  end

  def create
    if verify_recaptcha
      redirect_to root_path
    else
      render :new
    end
  end
end