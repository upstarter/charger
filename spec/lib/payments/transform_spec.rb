require_relative "../../../lib/payments/transactions/transform"
require_relative '../../../lib/customers/card'
require_relative '../../../lib/customers/customer'
require_relative '../../../lib/supervisor'


describe Charger::Transactions::Transform do

  let(:supervisor) { Charger::Supervisor.new(input: 'input.txt') }
  let(:transaction_supervisor) { Charger::Transactions::Supervisor.new(supervisor: supervisor) }


  context "adding new card" do
    context "VALID CARD" do
      let(:event) { "Add Tom 4111111111111111 $500" }

      it "creates new customer" do
        expect_any_instance_of(Charger::Customer).to receive(:initialize)
        subject.process(event: event, supervisor: transaction_supervisor)
      end

      it "creates new customer card" do
        expect_any_instance_of(Charger::Customer).to receive(:new_card)
        subject.process(event: event)
      end
    end

    context "INVALID CARD" do
      let(:event) { "Add Tom 1234567890123456 $500" }

      it "creates new customer" do
        expect_any_instance_of(Charger::Customer).to receive(:initialize)
        subject.process(event: event)
      end

      it "does not create new customer card" do
        expect_any_instance_of(Charger::Customer).not_to receive(:new_card)
        subject.process(event: event)
      end
    end


    context "with existing customer" do

    end
  end

  context "charging new customer with invalid card" do

  end

  context "charging existing card" do
    it "charges existing customer" do
      pending
    end
  end

  context "crediting existing card" do

  end

end
