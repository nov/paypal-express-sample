class TopController < ApplicationController
  def index
    @grouped_payments = [
      [Payment.new,                 Payment.recurring.build              ],
      [Payment.digital.build,       Payment.digital.recurring.build      ],
      [Payment.digital.popup.build, Payment.digital.popup.recurring.build]
    ]
  end
end
