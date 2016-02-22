require_relative "transaction"
require_relative "transform"

module Charger
  module Transactions
    class Supervisor
      attr_reader :transaction, :customers, :supervisor

      def initialize(supervisor:)
        @supervisor = supervisor
        @customers = Set.new
        @transform = Charger::Transactions::Transform.new
      end

      def transact(event)
        @response = @transform.process(event: event, supervisor: self)
        add_customer

        if card? && !new_card?
          @transaction = Charger::Transactions::Transaction.process(data: @response)
          [:"successful_#{transaction_type.downcase}", customer.name, "$#{@transform.amount.to_f}"]
        elsif card? && new_card?
          @response
        elsif !card?
          [customer.name, "error"]
        end
      end

      # ENRICHMENT SERVICES

      def new_card?
        @transform.new_card?
      end

      def invalid_card?
        @transform.invalid_card?
      end

      def transaction_type
        @transform.transaction_type
      end

      def add_customer
        @supervisor.customers << customer
        self.customers << customer
      end

      def customer
        @transform.customer
      end

      def card?
        @transform.card
      end
    end
  end
end
