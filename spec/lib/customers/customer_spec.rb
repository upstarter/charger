require 'money'
require_relative '../../../lib/customers/customer'
require_relative '../../../lib/customers/card'
require_relative '../../../lib/supervisor'
require_relative '../../../lib/payments/transactions/transaction'
require_relative '../../../lib/event_handler'
require_relative '../../../lib/payments/transactions/supervisor'

describe Charger::Customer do
  let(:supervisor) { Charger::Supervisor.new(input: 'input.txt') }
  let(:transaction_supervisor) { Charger::Transactions::Supervisor.new(supervisor: supervisor) }
  subject { Charger::Customer.new("Fred") }

  it "adds new cards" do
    expect(subject.cards).to be_empty
    subject.new_card("4111111111111111", 10_000)
    expect(subject.cards).not_to be_empty
  end

  it "provides balance for card" do
    subject.new_card("4111111111111111", 10_000)
    expect(subject.balance.to_f).to eq(0)

    proc = -> {
      Charger::EventHandler.new.process(event: "Add #{subject.cards.last.number} $10,000", supervisor: supervisor)
      Charger::Transactions::Transaction.process(data: [:credit, subject.cards.last, 50])
    }

    expect { proc.call }.to change { subject.balance }.by(Money.new(-50, :usd))
  end

end
