require_relative "version"
require_relative "summary_table"
require_relative "transaction"

module Charger
  class Parser
    attr_reader :filename, :data, :transaction

    DEFAULT_FILE = 'input.txt'

    def initialize(filename=DEFAULT_FILE, transaction_class=Transaction)
      @filename = filename || DEFAULT_FILE
      @transaction = transaction_class.new(@filename)
      @data = table_data
    end

    def render
      Charger::SummaryTable.draw data
    end

    private

    def table_header
      ["Name", "Balance"]
    end

    def table_rows
      @transaction.process
    end

    def table_data
      [table_header] + table_rows
    end
  end
end
