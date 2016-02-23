require_relative "../../../../lib/payments/transactions/supervisor"
require_relative "../../../../lib/views/summary_table"
require_relative "../../../../lib/supervisor"

describe Charger::Transactions::Supervisor do
  let(:supervisor) { Charger::Supervisor.new(input: 'input.txt') }
  let(:customer) { Charger::Customer.new("Tom") }
  let(:card) { Charger::Card.new(number: "4111111111111111", limit: "$500") }

  let(:handler) { Charger::EventHandler.new }
  let(:handler_response) { handler.process(event: event, supervisor: supervisor) }

  subject { described_class.new(supervisor: supervisor) }

  context "new card event" do
    let(:event) { "Add Tom 4111111111111111 $500" }

    it "returns response from the event handler" do
      expect(subject.transact(event)).to eq(handler_response)
    end
  end

  context "charge/credit event" do
    let(:add_event) { "Add Tom 4111111111111111 $500" }
    let(:event) { "Charge Tom $50" }

    it "delegates transaction to Charger::Transactions::Transaction" do
      subject.transact(add_event)
      expect(Charger::Transactions::Transaction).to receive(:process).with(data: handler_response).and_call_original
      subject.transact(event)
    end

    it "returns enrichment data to supervisor" do
      subject.transact(add_event)
      enriched = [:successful_charge, "Tom", "$50.0"]
      expect(subject.transact(event)).to eq(enriched)
    end
  end

  it "keeps hold of enriched customers data as it streams in" do

  end
end
