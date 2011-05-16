class PaymentsController < ApplicationController
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  def show
    @payment = Payment.find_by_identifier! params[:id]
  end

  def create
    payment = Payment.create! params[:payment]
    payment.setup!(client)
    if payment.popup?
      redirect_to payment.popup_uri
    else
      redirect_to payment.redirect_uri
    end
  end

  def destroy
    Payment.find_by_identifier!(params[:id]).unsubscribe!(client)
    redirect_to root_path, notice: 'Recurring Profile Canceled'
  end

  def success
    handle_callback do |payment|
      payment.complete!(client, params[:PayerID])
      flash[:notice] = 'Payment Transaction Completed'
      payment_url(payment.identifier)
    end
  end

  def cancel
    handle_callback do |payment|
      payment.cancel!
      flash[:warn] = 'Payment Request Canceled'
      root_url
    end
  end

  private

  def client
    Paypal::Express::Request.new PAYPAL_CONFIG.merge(
      return_url: success_payments_url,
      cancel_url: cancel_payments_url
    )
  end

  def handle_callback
    payment = Payment.find_by_token! params[:token]
    redirect_uri = yield payment
    if payment.popup?
      close_flow redirect_uri
    else
      redirect_to redirect_uri
    end
  end

  def close_flow(redirect_uri = root_url)
    @redirect_uri = redirect_uri
    flash.keep
    render :close_flow, layout:false
  end

  def paypal_api_error(e)
    redirect_to root_url, error: e.response.details.collect(&:long_message).join('<br />')
  end

end
