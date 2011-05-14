require 'paypal/express'

PAYPAL_CONFIG = if ENV['paypal_username'] # for heroku
  {
    username:  ENV['paypal_username'],
    password:  ENV['paypal_password'],
    signature: ENV['paypal_signature'],
    sandbox:   ENV['paypal_sandbox']
  }
else
  YAML.load_file("#{Rails.root}/config/paypal.yml")[Rails.env].symbolize_keys
end
Paypal.sandbox! if PAYPAL_CONFIG[:sandbox]