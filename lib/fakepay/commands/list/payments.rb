# frozen_string_literal: true

require 'bundler/setup'
require 'tty-table'

require_relative '../../command'
require_relative '../../coolpay_helper'
require_relative '../../tty_helper'

module Fakepay
  module Commands
    class List
      #
      # List payments
      #
      class Payments < Fakepay::Command
        include CoolpayHelper
        include TTYHelper

        HEADERS = %w[id amount currency recipient_id status].freeze

        def initialize(options)
          @options = options
        end

        def execute(_input: $stdin, output: $stdout)
          # Command logic goes here ...
          with_spinner('Login') { setup_coolpay }
          payments = with_spinner('Fetch payments') do
            Coolpay::Payment.list
          end

          output.puts "Found #{payments.length}"
          puts_tableized(output, payments, headers: HEADERS) do |p|
            [p.id, p.amount, p.currency, p.recipient_id, p.status]
          end
        end
      end
    end
  end
end
