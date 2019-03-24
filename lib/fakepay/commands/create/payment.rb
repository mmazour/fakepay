# frozen_string_literal: true

require 'bundler/setup'
require 'tty-table'

require_relative '../../command'
require_relative '../../coolpay_helper'
require_relative '../../tty_helper'

module Fakepay
  module Commands
    class Create
      #
      # Create payment by amount by amount, currency, and recipient id
      #
      class Payment < Fakepay::Command
        include CoolpayHelper
        include TTYHelper

        def initialize(amount, currency, recipient_id, options)
          @amount = amount
          @currency = currency
          @recipient_id = recipient_id
          @options = options
        end

        def execute(_input: $stdin, output: $stdout)
          # Command logic goes here ...
          with_spinner('Login') { setup_coolpay }
          payment = with_spinner('Create payment') do
            Coolpay::Payment.create(
              amount: @amount,
              currency: @currency,
              recipient: @recipient_id
            )
          end

          if payment
            puts_tableized(output, [payment], headers: PMT_HEADERS) do |p|
              payment_display_fields(p)
            end
          else
            output.puts 'Payment creation failed.'
          end
        end
      end
    end
  end
end
