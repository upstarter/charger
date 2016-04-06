require_relative 'payments/transactions/transaction'
require_relative 'payments/transactions/supervisor'

module Charger
	class Extractor
    attr_reader :input, :supervisor, :transaction_supervisor, :tranformation

    def initialize(input:, supervisor:)
      @input = input || supervisor.class::DEFAULT_FILE
      @supervisor = supervisor
      @transaction_supervisor = Charger::Transactions::Supervisor.new(supervisor: @supervisor)
      @transformation = []
    end

    def extract
      if ARGV.empty? || ARGV.include?('input.txt') || ENV['RACK_ENV'] = 'test'
        take_file
      else
        take_stdin
      end
    end

    def take_stdin
      STDIN.read.split("/n").each do |event|
        @transformation << @transaction_supervisor.transact(event)
      end
    end

    def take_file
      File.open(input, "r") do |file|
        file.each_line do |event|
          @transformation << @transaction_supervisor.transact(event)
        end
      end
      @transformation
    end

  end
end
