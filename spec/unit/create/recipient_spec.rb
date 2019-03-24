# frozen_string_literal: true

require 'fakepay/commands/create/recipient'
require 'vcr'

RSpec.describe Fakepay::Commands::Create::Recipient do
  VCR.configure do |config|
    config.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
    config.hook_into :webmock
  end

  it 'executes `create recipient {name}` command successfully' do
    output = StringIO.new
    options = {}

    VCR.use_cassette('create_recipient') do
      command =
        Fakepay::Commands::Create::Recipient.new('Jake McFriend', options)
      command.execute(output: output)
    end

    expect(output.string).to match(/e9a0336b-d81d-4009-9ad1-8fa1eb43418c/)
    expect(output.string).to match(/Jake McFriend/)
  end
end
