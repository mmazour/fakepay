# frozen_string_literal: true

require 'fakepay/commands/find/payment'

RSpec.describe Fakepay::Commands::Find::Payment do
  it 'executes `find payment {id}` command successfully' do
    output = StringIO.new
    options = {}

    VCR.use_cassette('find_payment') do
      command = Fakepay::Commands::Find::Payment.new(
        '31db334f-9ac0-42cb-804b-09b2f899d4d2',
        options
      )
      command.execute(output: output)
    end

    # Check payment id, amount, currency, recipient id, and status
    expect(output.string).to match(/31db334f-9ac0-42cb-804b-09b2f899d4d2/)
    expect(output.string).to match(/10\.5/)
    expect(output.string).to match(/gbp/)
    expect(output.string).to match(/6e7b146e-5957-11e6-8b77-86f30ca893d3/)
    expect(output.string).to match(/paid/)
  end
end
