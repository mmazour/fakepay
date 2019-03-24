# frozen_string_literal: true

require 'thor'

module Fakepay
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'fakepay version'
    def version
      require_relative 'version'
      puts "v#{Fakepay::VERSION}"
    end
    map %w[--version -v] => :version

    require_relative 'commands/list'
    register Fakepay::Commands::List,
             'list',
             'list [payments || recipients]',
             '`list recipients` to list recipients, or ' \
               '`list payments` to list payments'
  end
end
