# frozen_string_literal: true

require 'thor'

module Fakepay
  module Commands
    #
    # Find a recipient or a payment
    #
    class Create < Thor
      namespace :create

      desc 'recipient', 'Create a recipient by name'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Create a recipient by name.'
      def recipient(new_name)
        if options[:help]
          invoke :help, ['recipient']
        else
          require_relative 'create/recipient'
          Fakepay::Commands::Create::Recipient.new(new_name, options).execute
        end
      end

      desc 'payment', 'Create a payment by amount, currency, and recipient'
      method_option(
        :help,
        aliases: '-h',
        type: :boolean,
        desc: 'Create a payment by amount, currency, and recipient.'
      )
      def payment(amount, currency, recipient_id)
        if options[:help]
          invoke :help, ['payment']
        else
          require_relative 'create/payment'
          Fakepay::Commands::Create::Payment.new(
            amount,
            currency,
            recipient_id,
            options
          ).execute
        end
      end
    end
  end
end
