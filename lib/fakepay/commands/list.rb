# frozen_string_literal: true

require 'thor'

module Fakepay
  module Commands
    #
    # List recipients or payments
    #
    class List < Thor
      namespace :list

      desc 'recipients', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def recipients(*)
        if options[:help]
          invoke :help, ['recipients']
        else
          require_relative 'list/recipients'
          Fakepay::Commands::List::Recipients.new(options).execute
        end
      end
    end
  end
end
