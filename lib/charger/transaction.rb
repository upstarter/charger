require 'money'
require 'byebug'
Money.use_i18n = false

#TODO: Refactor in order to delegate to Customer --> (HAS_MANY) --> Account(s) And Card classes in accordance
# with solid design principles (single responsibility principle)
module Charger
	class Transaction
    attr_reader :filename, :line, :customer, :account, :card
    attr_accessor :type, :customer, :cc_num, :amount

    def initialize(filename)
      @filename = filename

      @customers = Hash.new do |h, key|
        h[key] = Hash.new
        h[key][:limit] = 0
        h[key][:balance] = 0
      end
    end

    def process
      File.open(filename, "r") do |file|
        file.each_line do |line|
          populate(line)
          coerce_vars
          transact(type)
        end
      end
      arrange_rows
    end

private

    def populate(line)
      data = line.split(' ')
      if data.first == "Add"
        @type, @customer, @cc_num, @amount = data
      else
        @type, @customer, @amount = data
      end
    end

    def coerce_vars
      self.type = coerce_type # correct erroneous terminology of input
      self.customer = customer.capitalize.to_sym
      self.amount = Money.new(amount[/\d+/], "USD") * 100
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

    def arrange_rows
      @customers.inject([]) do |acc, customer|
        acc << render_row(customer)
      end
    end

    def render_row(customer)
      out = if customer.last[:cc_num_valid]
              customer.last[:balance].format
            else
              "error"
            end
      [customer.first.to_s.capitalize, out]
    end

    def transact(type)      
      send(type)
    end

    def add
      @customers[customer]
      @customers[customer][:cc_num] = cc_num
      @customers[customer][:limit] = amount
      @customers[customer][:cc_num_valid] = credit_card_valid?
    end

    def credit
      return if overlimit?
      @customers[customer][:balance] += amount
    end

    def debit
      @customers[customer][:balance] -= amount
    end

    def limit
      @customers[customer][:limit]
    end

    def balance
      @customers[customer][:balance]
    end

    def overlimit?
      balance + amount > limit
    end

    def credit_card_valid?
      # using luhn10
      digits = cc_num.scan(/./).map(&:to_i)
      check = digits.pop

      sum = digits.reverse.each_slice(2).map do |x, y|
        [(x * 2).divmod(10), y || 0]
      end.flatten.inject(:+)

      (10 - sum % 10) == check
    end
  end
end