# frozen_string_literal: true

require 'fakepay/commands/list/payments'
require 'vcr'

RSpec.describe Fakepay::Commands::List::Payments do
  VCR.configure do |config|
    config.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
    config.hook_into :webmock
  end

  it 'executes `list payments` command successfully' do
    output = StringIO.new
    options = {}

    VCR.use_cassette('list_payments') do
      command = Fakepay::Commands::List::Payments.new(options)
      command.execute(output: output)
    end

    # Check count, payment id, amount, currency, recipient id, and status
    expect(output.string).to match(/Found 1/)
    expect(output.string).to match(/31db334f-9ac0-42cb-804b-09b2f899d4d2/)
    expect(output.string).to match(/10\.5/)
    expect(output.string).to match(/gbp/)
    expect(output.string).to match(/6e7b146e-5957-11e6-8b77-86f30ca893d3/)
    expect(output.string).to match(/paid/)
  end
end
