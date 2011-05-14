class Payment < ActiveRecord::Base
  validates :token, uniqueness: true
  validates :amount, presence: true
  scope :recurring, where(recurring: true)
  scope :digital,   where(digital: true)

  attr_reader :redirect_uri, :popup_uri

  def setup!(client)
    response = client.setup(
      payment_request,
      pay_on_paypal: true,
      no_shipping: self.digital?
    )
    self.token = response.token
    self.save!
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self
  end

  private

  def payment_request
    request_attributes = if self.recurring?
      {
        billing_type: :RecurringPayments,
        billing_agreement_description: 'Billing Agreement Description'
      }
    else
      item = {
        name: 'Item Name',
        description: 'Item Description',
        amount: self.amount
      }
      item[:category] = :Digital if self.digital?
      {
        amount: self.amount,
        description: 'Description',
        items: [item]
      }
    end
    Paypal::Payment::Request.new request_attributes
  end

  def recurring_request
    Paypal::Payment::Recurring.new(
      start_date: Time.now,
      description: 'Description',
      billing: {
        period: :Month,
        frequency: 1,
        amount: self.amount
      }
    )
  end

end
