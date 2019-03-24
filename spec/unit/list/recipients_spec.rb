# frozen_string_literal: true

require 'fakepay/commands/list/recipients'

RSpec.describe Fakepay::Commands::List::Recipients do
  it 'executes `list recipients` command successfully' do
    output = StringIO.new
    options = {}
    command = Fakepay::Commands::List::Recipients.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
