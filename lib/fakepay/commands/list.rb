# frozen_string_literal: true

require 'thor'

module Fakepay
  module Commands
    #
    # List recipients or payments
    #
    class List < Thor
      namespace :list

      desc 'recipients', 'List all recipients'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'List all recipients in the system.'
      def recipients(*)
        if options[:help]
          invoke :help, ['recipients']
        else
          require_relative 'list/recipients'
          Fakepay::Commands::List::Recipients.new(options).execute
        end
      end

      desc 'payments', 'List all payments'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'List all payments in the system'
      def payments(*)
        if options[:help]
          invoke :help, ['payments']
        else
          require_relative 'list/payments'
          Fakepay::Commands::List::Payments.new(options).execute
        end
      end
    end
  end
end
