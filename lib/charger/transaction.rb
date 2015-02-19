require_relative 'card'

module Charger
	class Transaction
    attr_reader :filename, :line, :customer, :card
    attr_accessor :type, :customer, :cc_num, :amount

    def initialize(filename)
      @filename = filename

      @customers = Hash.new do |h, key|
        h[key] = Hash.new
        h[key][:cards] = []
      end
    end

    def process
      File.open(filename, "r") do |file|
        file.each_line do |line|
          line = arrange_data(line)
          populate_self(line)
          coerce_vars
          transact(type)
        end
      end
      arrange_rows
    end

private

    def arrange_data(line)
      line = line.split(' ')
      @new_card = line[0] == "Add"
      line[1] = line[1].capitalize.to_sym
      if new_card?
        line[3] = Money.new(line[3][/\d+/], "USD") * 100
      end
      line
    end

    def populate_self(line)
      if line.first == "Add"
        @type, @customer, @cc_num, @amount = line
        @card = find_card
      else
        @type, @customer, @amount = line
        @card = @customers[customer][:cards].first
      end
    end

    def coerce_vars
      self.type = coerce_type # correct erroneous terminology of input
      self.customer = customer.capitalize.to_sym
      unless new_card?
        self.amount = Money.new(amount[/\d+/], "USD") * 100
      end
    end  

    def new_card?
      @new_card
    end

    def coerce_type
      coerced = type.downcase.to_sym
      correct_type = case coerced
        when :charge
          :credit
        when :credit
          :debit
        else
          coerced
        end
      correct_type
    end

    def find_card
      @customers[customer]
      card = @customers[customer][:cards].find { |card| card.number == @cc_num }

      unless card
        card = Card.new(number: @cc_num, limit: @amount)
        @customers[customer][:cards] << card
      end
      card
    end

    def arrange_rows
      @customers.inject([]) do |acc, customer|
        card = customer.last[:cards].first
        acc << render_row(customer, card)
      end
    end

    def render_row(customer, card)
      msg = card.balance.zero? ? "$0" : card.balance.format
      out = if card.valid
              msg
            else
              "error"
            end
      [customer.first.to_s.capitalize, out]
    end

    def transact(type)      
      @card.send(type, amount) unless type == :add
    end

  end

end