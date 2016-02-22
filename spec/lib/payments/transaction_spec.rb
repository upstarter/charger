require 'money'
Money.use_i18n = false

require_relative "../../../lib/payments/transactions/transaction"
require_relative '../../../lib/customers/card'


describe Charger::Transactions::Transaction do

  let(:card) { Charger::Card.new(number: "4111111111111111", limit: 10_000) }

  it "charges" do
    expect(card.balance).to eq(0)
    expect(card).to receive(:charge).with(50).and_call_original
    expect { described_class.process(data: ["Charge", card, 50]) }.to change { card.balance }.by(50)
  end

  it "credits" do
    expect(card.balance).to eq(0)
    expect(card).to receive(:credit).with(50).and_call_original
    expect { described_class.process(data: ["Credit", card, 50]) }.to change { card.balance }.by(-50)
  end

end
