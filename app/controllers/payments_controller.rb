class PaymentsController < ApplicationController
  def create
    payment = Payment.create! params[:payment]
    redirect_to root_url
  end
end
