# Charger

Basic Credit Card Processing
----------------------------

This is a very basic credit card processing program to demonstrate knowledge of Object Oriented Programming practices for payments processing.

## Usage

Ensure you have ruby installed ( the program was developed and tested using Ruby 2.1.5p273 and Rspec version 3.2.0).

And then execute:

    $ ruby lib/app.rb

Tests are in the /spec folder. In the interest of time, adding tests for the code used for rendering output on the command line was skipped.

## Design Decisions

The design was inspired by the Erlang OTP actor style Supervisor/Worker paradigm. The Object model was envisioned as a data supervision tree mixed with a data pipelining Microservice performing ETL functions. Not exactly perfect for a high throughput transaction system, but useful nonetheless.

One could easily repurpose this app for messaging to/from an event bus or to do analysis on Large Datasets. Think of the Charger::Supervisor as the High Level Policy object that directs the action of and collects results from the subordinate Charger::Transactions::Supervisor whom directs it's workers in the completion of small amounts of work on vectors to enrich information for the supervisor which can direct more work based on accumulative and/or terminal results and in "real time". Supervisors are coupled to eachother and workers so as to allow a high level of coordination in the successful implementation of the policies.

The program was built using SOLID principles. In thinking of future requirements, the architecture supports multiple customer accounts(cards). Currently, without a database or framework like Rails, the Card model is synonomous with a customer account, but could easily be adapted to support a seperate Account model with possibly many cards. The code can also easily be changed to allow the transactions to include multiple cards per user.

For example, a future refactoring may look like:

Customer --> (HAS_MANY) --> Account(s) --> (HAS_MANY) --> Cards

or, in Rails lingo, something like:

class Customer
	has_many :accounts
	has_many :cards, through: :accounts
end

class Account
	belongs_to :customer
	has_many :cards
end

class Card
	belongs_to :account

	delegate :customer, to: :account
end


## Why Ruby?

I chose Ruby because of it's terse syntax and the ease of which prototyping can be rapidly implemented, the availability of a wide variety of libraries(gems), as well as the general feeling of happiness that comes from daily use.