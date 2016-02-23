require_relative '../../lib/event_handler'
require_relative '../../lib/customers/card'
require_relative '../../lib/customers/customer'
require_relative '../../lib/supervisor'


describe Charger::EventHandler do

  let(:supervisor) { Charger::Supervisor.new(input: 'input.txt') }
  let(:transaction_supervisor) { Charger::Transactions::Supervisor.new(supervisor: supervisor) }


  context "adding new card" do
    context "VALID CARD" do
      let(:event) { "Add Tom 4111111111111111 $500" }

      it "creates new customer" do
        expect(Charger::Customer).to receive(:new).and_call_original
        subject.process(event: event, supervisor: transaction_supervisor)
      end

      it "creates new customer card" do
        expect_any_instance_of(Charger::Customer).to receive(:new_card).and_call_original
        subject.process(event: event, supervisor: transaction_supervisor)
      end
    end

    context "INVALID CARD" do
      let(:event) { "Add Tom 1234567890123456 $500" }

      it "creates new customer" do
        expect(Charger::Customer).to receive(:new).and_call_original
        subject.process(event: event, supervisor: transaction_supervisor)
      end

      it "does not create new customer card" do
        expect_any_instance_of(Charger::Customer).to receive(:new_card).and_call_original
        result = subject.process(event: event, supervisor: transaction_supervisor)
        expect(result.first).to eq(:invalid_card_creation_attempt)
      end
    end

    context "existing customer" do
      let(:event) { "Add Tom 4111111111111111 $500" }
      it "finds the customer through the supervisor" do
        expect(transaction_supervisor).to receive_message_chain(:customers, :find)
        subject.process(event: event, supervisor: transaction_supervisor)
      end
    end
  end

  context "charging/crediting customer" do
    let(:event) { "Charge Tom $10" }
    before { transaction_supervisor.customers << Charger::Customer.new("Tom") }
    it "does not create new customer" do
      expect(Charger::Customer).not_to receive(:new)
      subject.process(event: event, supervisor: transaction_supervisor)
    end
  end


end
