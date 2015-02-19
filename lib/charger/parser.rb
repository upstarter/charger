require_relative "version"
require_relative "summary_table"
require_relative "transactioner"

module Charger
  class Parser
    attr_reader :filename, :data

    DEFAULT_FILE = 'input.txt'

    def initialize filename=DEFAULT_FILE
      @filename = filename || DEFAULT_FILE
      @transactioner = Transactioner.new(@filename)
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
      @transactioner.process
    end

    def table_data
      [table_header] + table_rows
    end
  end
end
