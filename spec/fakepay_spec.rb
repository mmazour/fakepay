# frozen_string_literal: true

require 'coolpay'

RSpec.describe Fakepay do
  it 'has a version number' do
    expect(Fakepay::VERSION).not_to be nil
  end

  it 'loads Coolpay' do
    expect(Coolpay).to be
    expect(Coolpay::Recipient).to be
    expect(Coolpay::Payment).to be
  end
end
