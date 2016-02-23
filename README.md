# Charger

Basic Credit Card Processing
----------------------------

This is a credit card processing microservice to demonstrate knowledge of Object Oriented Modeling practices for payments oriented purposes.

## Usage

Ensure you have ruby installed ( the program was developed and tested using Ruby 2.1.5p273 and Rspec version 3.2.0).

And then execute:

    $ ruby lib/app.rb

    - OR SPECIFY FILE -

    $ ruby lib/app.rb 'input.txt'

    - OR STDIN -

    $ ruby lib/app.rb < input.txt

Tests are in the /spec folder. In the interest of time, adding tests for the code used for rendering output on the command line was skipped.

To run tests:

    $ rspec spec/

## Design Decisions

The design of this solution to customer events was inspired by the Erlang OTP actor style Supervisor/Worker paradigm. The Object model was envisioned as a data supervision tree mixed with a data pipelining Microservice performing ETL functions. Not exactly perfect for a high performance transaction system, but useful as an exercise in OO Modeling of customer solutions.

One could easily repurpose this app for messaging to/from an event bus or to do analysis on Large Datasets. Think of the Charger::Supervisor as the High Level Policy object that directs the action of and collects results from the subordinate Charger::Transactions::Supervisor whom coordinates it's workers to filter/enrich the information for the supervisor whom can direct more work based on real time accumulative and/or terminal results. Supervisors are coupled to eachother and workers so as to facilitate a high level of coordination in the implementation of cohesive strategic policies.

## Why Ruby?

I chose Ruby because of it's terse syntax and the ease of which prototyping can be rapidly implemented, the availability of a wide variety of libraries(gems), as well as the general feeling of happiness that comes from daily use.