# frozen_string_literal: true

require 'fakepay/commands/list/recipients'

RSpec.describe Fakepay::Commands::List::Recipients do
  it 'executes `list recipients` command successfully' do
    output = StringIO.new
    options = {}

    VCR.use_cassette('list_recipients') do
      command = Fakepay::Commands::List::Recipients.new(options)
      command.execute(output: output)
    end

    expect(output.string).to match(/Found 1/)
    expect(output.string).to match(/6e7b4cea-5957-11e6-8b77-86f30ca893d3/)
    expect(output.string).to match(/Jake McFriend/)
  end
end
