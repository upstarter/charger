# I attached your originally solution and the new instructions for the code challenge. Reminder, now it has to read input from file and STDIN.

# The feedback from over a year ago to help---

# - Obviously an experienced Ruby user with some good practices.
# My main concern is his strength in OO modeling.
# I think it'll be important to press him on this in moving forward.
# - Nice that it's a gem. Good file structure. Well organized.
# Would have liked a bit more design rationale in Readme as well as instructions on how to run tests, but still fine.
# - Does not take stdin -- Does take from file
# - Very legible and well-formatted
# - Test coverage is incomplete, but at least he mentions this in the Readme
# - Overall, idiomatic ruby. Red flag-  sending signals via instance variables, rather than passing variables as arguments to methods.
# - He starts out pretty well with a Card class, but the Transaction class encapsulates entirely too much functionality,
# including parsing the input file, which is weird since he also has a class called Parser, which doesn't parse anything.
require_relative 'payments/transactions/transaction'
require_relative 'payments/transactions/supervisor'

module Charger
	class Extractor
    attr_reader :input, :supervisor, :transaction_supervisor, :tranformation

    def initialize(input:, supervisor:)
      @input = input
      @supervisor = supervisor
      @transaction_supervisor = Charger::Transactions::Supervisor.new(supervisor: @supervisor)
      @transformation = []
    end

    def extract
      if !ARGV.empty? && ARGV.first != 'spec'
        take_stdin
      else
        take_file
      end
    end

    def take_stdin
      ARGV.each do |event|
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
