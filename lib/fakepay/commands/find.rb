# frozen_string_literal: true

require 'thor'

module Fakepay
  module Commands
    #
    # Find a recipient or a payment
    #
    class Find < Thor
      namespace :find

      desc 'recipient', 'Find a recipient by name'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Find a recipient by name.'
      def recipient(search_name)
        if options[:help]
          invoke :help, ['recipient']
        else
          require_relative 'find/recipient'
          Fakepay::Commands::Find::Recipient.new(search_name, options).execute
        end
      end

      desc 'payment', 'Find a payment by id'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Find a payment by id.'
      def payment(id)
        if options[:help]
          invoke :help, ['payment']
        else
          require_relative 'find/payment'
          Fakepay::Commands::Find::Payment.new(id, options).execute
        end
      end
    end
  end
end
