# frozen_string_literal: true

require 'yaml'

module Fakepay
  #
  # Helper methods for working with Coolpay
  #
  module CoolpayHelper
    require 'coolpay'

    CONFIG_FILE_NAME = '.coolpay.yml'

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

    def coolpay_configured?
      !(Coolpay.api_url && Coolpay.username && Coolpay.api_key).nil?
    end

    def configure_coolpay
      return if coolpay_configured?

      # Config file takes precedence
      if FileTest.exist?(CONFIG_FILE_NAME)
        config = YAML.safe_load(File.read(CONFIG_FILE_NAME))
        Coolpay.api_url = config.dig('coolpay', 'api_url')
        Coolpay.username = config.dig('coolpay', 'username')
        Coolpay.api_key = config.dig('coolpay', 'api_key')
      end

      # Use env vars for anything not already set
      Coolpay.api_url ||= ENV['COOLPAY_API_URL']
      Coolpay.username ||= ENV['COOLPAY_USERNAME']
      Coolpay.api_key ||= ENV['COOLPAY_API_KEY']
    end
  end
end
