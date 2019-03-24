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
      # Create recipient by name
      #
      class Recipient < Fakepay::Command
        include CoolpayHelper
        include TTYHelper

        def initialize(new_name, options)
          @new_name = new_name
          @options = options
        end

        def execute(_input: $stdin, output: $stdout)
          # Command logic goes here ...
          with_spinner('Login') { setup_coolpay }
          recipient = with_spinner('Create recipient') do
            Coolpay::Recipient.create(@new_name)
          end

          if recipient
            puts_tableized(output, [recipient], headers: RCP_HEADERS) do |r|
              recipient_display_fields(r)
            end
          else
            output.puts 'Recipient creation failed.'
          end
        end
      end
    end
  end
end
