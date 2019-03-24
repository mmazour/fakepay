# frozen_string_literal: true

require 'fakepay/commands/find/recipient'
require 'vcr'

RSpec.describe Fakepay::Commands::Find::Recipient do
  VCR.configure do |config|
    config.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
    config.hook_into :webmock
  end

  it 'executes `list recipients` command successfully' do
    output = StringIO.new
    options = {}

    VCR.use_cassette('find_recipient') do
      command = Fakepay::Commands::Find::Recipient.new('Jake McFriend', options)
      command.execute(output: output)
    end

    expect(output.string).to match(/6e7b4cea-5957-11e6-8b77-86f30ca893d3/)
    expect(output.string).to match(/Jake McFriend/)
  end
end
