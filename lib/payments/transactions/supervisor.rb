require_relative "transaction"
require_relative "../../event_handler"

module Charger
  module Transactions
    class Supervisor
      attr_reader :transaction, :customers, :supervisor

      def initialize(supervisor:)
        @supervisor = supervisor
        @customers = Set.new
        @handler = Charger::EventHandler.new
      end

      def transact(event)
        @response = @handler.process(event: event, supervisor: self)
        add_customer

        if card? && !new_card?
          @transaction = Charger::Transactions::Transaction.process(data: @response)
          [:"successful_#{transaction_type.downcase}", customer.name, "$#{@handler.amount.to_f}"]
        elsif card? && new_card?
          @response
        elsif !card?
          [customer.name, "error"]
        end
      end

      def new_card?
        @handler.new_card?
      end

      def invalid_card?
        @handler.invalid_card?
      end

      def transaction_type
        @handler.transaction_type
      end

      def add_customer
        @supervisor.customers << customer
        self.customers << customer
      end

      def customer
        @handler.customer
      end

      def card?
        @handler.card
      end
    end
  end
end
