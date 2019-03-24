# frozen_string_literal: true

module Fakepay
  #
  # Helper methods for working with Coolpay
  #
  module CoolpayHelper
    require 'coolpay'

    module_function

    def setup_coolpay
      configure_coolpay
      Coolpay.authorize
      return if Coolpay.authorized?

      raise <<~DOC
        Failed to log in to Coolpay!
        You must set api_url, username, and api_key to valid values.
        How? # TODO
      DOC
    end

    def configure_coolpay
      Coolpay.api_url ||= 'https://private-6d20e-coolpayapi.apiary-mock.com/api'
      Coolpay.username ||= 'your_username'
      Coolpay.api_key ||= '5up3r$ecretKey!'
    end
  end
end
