module Charger
  class Card
    attr_accessor :number, :limit, :valid, :balance

    def initialize(number:, limit:)
      @balance = 0
      @number = number
      @limit = limit
      @valid = luhn_check
    end

    def credit(amount)
      return if overlimit?(amount)
      @balance += amount
    end

    def debit(amount)
      @balance -= amount
    end

    def overlimit?(amount)
      balance + amount > limit
    end

    def luhn_check
      s1 = s2 = 0
      number.to_s.reverse.chars.each_slice(2) do |odd, even| 
        s1 += odd.to_i
     
        double = even.to_i * 2
        double -= 9 if double >= 10
        s2 += double
      end
      (s1 + s2) % 10 == 0
    end
    
  end
end