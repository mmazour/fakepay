# frozen_string_literal: true

require 'thor'
require 'optparse'

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
      def payment(*args)
        params = parse_payment_args(args)

        if options[:help]
          invoke :help, ['payment']
        else
          require_relative 'create/payment'
          Fakepay::Commands::Create::Payment.new(
            params[:amount],
            params[:currency],
            params[:recipient],
            options
          ).execute
        end
      end

      private

      def parse_payment_args(args)
        parser = OptionParser.new do |opts|
          opts.banner = 'Usage: fakepay create payment [options]'
          opts.on '--amount AMOUNT', 'the amount'
          opts.on '--currency CURRENCY', 'the currency, e.g. "GBP"'
          opts.on '--recipient RECIPIENT_ID', "the recipient's ID"
        end
        params = {}
        begin
          parser.parse!(args, into: params)
          missing = %i[amount currency recipient] - params.keys
          if missing.any?
            missing.each { |m| STDERR.puts "Missing required argument: --#{m}" }
            raise OptionParser::MissingArgument, 'request incomplete'
          end
        rescue OptionParser::MissingArgument, OptionParser::InvalidOption => e
          STDERR.puts e.message
          STDERR.puts parser
          exit(1)
        end
        params
      end
    end
  end
end
