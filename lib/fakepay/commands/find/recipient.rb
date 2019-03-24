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
      # Find recipient by name
      #
      class Recipient < Fakepay::Command
        include CoolpayHelper
        include TTYHelper

        def initialize(search_name, options)
          @search_name = search_name
          @options = options
        end

        def execute(_input: $stdin, output: $stdout)
          # Command logic goes here ...
          with_spinner('Login') { setup_coolpay }
          recipient = with_spinner('Search for recipient') do
            Coolpay::Recipient.find(@search_name)
          end

          if recipient
            puts_tableized(output, [recipient], headers: %w[id name]) do |r|
              [r.id, r.name]
            end
          else
            output.puts 'Recipient not found.'
          end
        end
      end
    end
  end
end
