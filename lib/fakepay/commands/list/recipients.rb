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
      # List recipients
      #
      class Recipients < Fakepay::Command
        include CoolpayHelper
        include TTYHelper

        def initialize(options)
          @options = options
        end

        def execute(_input: $stdin, output: $stdout)
          # Command logic goes here ...
          with_spinner('Login') { setup_coolpay }
          recipients = with_spinner('Fetch recipients') do
            Coolpay::Recipient.list
          end

          output.puts "Found #{recipients.length}"
          puts_tableized(output, recipients, headers: %w[id name]) do |r|
            [r.id, r.name]
          end
        end
      end
    end
  end
end
