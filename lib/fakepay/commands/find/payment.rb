# frozen_string_literal: true

require 'bundler/setup'
require 'tty-table'

require_relative '../../command'
require_relative '../../coolpay_helper'
require_relative '../../tty_helper'

module Fakepay
  module Commands
    class Find
      #
      # Find payment by id
      #
      class Payment < Fakepay::Command
        include CoolpayHelper
        include TTYHelper

        HEADERS = %w[id amount currency recipient_id status].freeze

        def initialize(search_id, options)
          @search_id = search_id
          @options = options
        end

        def execute(_input: $stdin, output: $stdout)
          # Command logic goes here ...
          with_spinner('Login') { setup_coolpay }
          payment = with_spinner('Search for payment') do
            # Coolpay doesn't have a find-payment API, so get all the payments
            # and sift through them for a matching one.
            payments = Coolpay::Payment.list
            payments.find { |p| p.id == @search_id }
          end

          if payment
            puts_tableized(output, [payment], headers: HEADERS) do |p|
              [p.id, p.amount, p.currency, p.recipient_id, p.status]
            end
          else
            output.puts 'Payment not found.'
          end
        end
      end
    end
  end
end
