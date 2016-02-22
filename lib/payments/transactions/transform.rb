require_relative '../../customers/customer'
require_relative '../../customers/card'

# This low level class deciphers each input event for processing upstream, and happens to also update the
# customer which I am not a big fan of but left for the sake of delivery and/or
# until further refactoring is needed
# stayed with generic name Transform
# could have just as easily been named EventHandler or something more concrete
module Charger
  module Transactions
    class Transform
      attr_accessor :supervisor, :transaction_type
      attr_reader :customer, :card, :amount

      def process(event:, supervisor: nil)
        @supervisor = supervisor
        handle(event)
        if new_card?
          new_card_response
        else
          [@transaction_type, @card, @amount]
        end
      end

      def new_card?
        @event.first == "Add"
      end

      def invalid_card?
        !@card.valid?
      end

    private

      def handle(event)
        @event = event.split(' ')
        if new_card?
          @transaction_type, @customer_name, @cc_num, @amount = @event
        else
          @transaction_type, @customer_name, @amount = @event
        end
        transform_amount
        @customer = @supervisor.customers.find { |customer| customer.name == @customer_name }
        update_customer
        @card = @customer.cards.last
      end

      def new_card_response
        if card && invalid_card?
          [:invalid_card_creation_attempt, @customer.name, "$#{@amount.to_f}"]
        else
          [:new_card_created, @customer_name, "$#{@amount.to_f}"]
        end
      end

      def update_customer
        if new_card?
          @customer ||= Charger::Customer.new(@customer_name)
          @customer.new_card(@cc_num, @amount)
        end
      end

      def transform_amount
        amt = @amount[/\d+/]
        @amount = Money.new(amt, "USD") * 100
      end
    end
  end
end
