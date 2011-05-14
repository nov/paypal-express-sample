class PaymentsController < ApplicationController

  def create
    payment = Payment.create! params[:payment]
    payment.setup!(client)
    if params[:popup].present?
      redirect_to payment.popup_uri
    else
      redirect_to payment.redirect_uri
    end
  end

  private

  def client
    Paypal::Express::Request.new PAYPAL_CONFIG.merge(
      return_url: success_payments_url,
      cancel_url: cancel_payments_url
    )
  end

end
