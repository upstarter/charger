module Charger
  class Customer
    attr_reader :name
    attr_accessor :cards

    InvalidCardError = Class.new(StandardError)

    def initialize(name)
      @name = name
      self.cards = []
    end

    def new_card(number, limit)
      self.cards << Card.new(number: number, limit: limit)
    end

    def add_card(card)
      self.cards << card
    end

    def balance(card: nil)
      return "error" if self.cards.empty? || self.cards.all? { |card| !card.valid? }
      balance = self.cards.inject(0) { |sum, card| sum += card.balance }
      Money.new(balance, :usd)
    end
  end
end
