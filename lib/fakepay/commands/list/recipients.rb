# frozen_string_literal: true

require 'bundler/setup'
require 'tty-table'

require_relative '../../command'
require_relative '../../coolpay_helper'

module Fakepay
  module Commands
    class List
      #
      # List recipients
      #
      class Recipients < Fakepay::Command
        include CoolpayHelper

        def initialize(options)
          @options = options
        end

        def execute(_input: $stdin, output: $stdout)
          # Command logic goes here ...
          setup_coolpay
          recipients = Coolpay::Recipient.list
          output.puts "Found #{recipients.length}"

          table = TTY::Table.new(
            header: ['id', 'name'],
            rows: recipients.map { |r| [r.id, r.name] }
          )
          output.puts table.render(:ascii)
          output.puts 'OK'
        end
      end
    end
  end
end
