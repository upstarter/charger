require 'money'
require_relative "version"
require_relative "views/summary_table"
require_relative "extractor"
Money.use_i18n = false

require 'byebug'

module Charger
  class Supervisor
    attr_reader :input, :matrix
    attr_accessor :customers

    DEFAULT_FILE = 'input.txt'

    def initialize(input:, extractor: Extractor, view: Charger::SummaryTable)
      @input = input || DEFAULT_FILE
      @customers = []
      @extractor_class = extractor
      @view = view
    end

    def extract
      @extractor = @extractor_class.new(input: @input, supervisor: self)
      @matrix = @extractor.extract
      @transaction_supervisor = @extractor.transaction_supervisor #  extraction informs supervisor
      @customers = @transaction_supervisor.customers

      @tail = @customers.map do |customer|
        balance = customer.balance == "error" ? "error" : customer.balance.format
        [customer.name, balance]
      end
    end

    def draw
      @view.draw data
    end

    def data
      [head] + @tail
    end

  private

    def head
      ["Name", "Balance"]
    end

  end
end
