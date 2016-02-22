module Charger
  module Transactions
    class Transaction
      attr_reader :type, :status

      def self.process(data:)
        new(data: data).process
      end

      def initialize(data:)
        @type   = data.first
        @card   = data[1]
        @amount = data[2]
      end

      def process
        @status = @card.send(@type.downcase.to_sym, @amount)
        self
      end
    end
  end
end
