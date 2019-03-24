# frozen_string_literal: true

module Fakepay
  #
  # Helper methods for working with TTY
  #
  module TTYHelper
    require 'tty-table'
    require 'tty-spinner'

    module_function

    #
    # Display a spinner while yielding out to a block.
    #
    def with_spinner(message)
      spinner = TTY::Spinner.new("[:spinner] #{message}...")
      result = yield
      spinner.stop('Done.')
      result
    rescue StandardError => err
      spinner.error('error.')
      raise err
    end

    #
    # Returns an ASCII table representation of a data set. Yields each data
    # item to a block, which should return an array of values for one row.
    # Optional/recommended: provide an array of table headers.
    #
    def tableize(data, headers: nil)
      rows = data.map { |row| yield row }
      table = TTY::Table.new(header: headers, rows: rows)
      table.render(:ascii)
    end

    #
    # Tableize data and puts it to an output.
    # (This avoids a little awkwardness when puts-ing a method taking a block.)
    #
    def puts_tableized(output, data, headers: nil, &block)
      table = tableize(data, headers: headers, &block)
      output.puts table
    end
  end
end
