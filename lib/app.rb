require "optparse"
require 'byebug'
require 'money'
Money.use_i18n = false
require_relative "charger/parser"

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #$0 -f file"

  opts.on "-f", "--file FILENAME", "Input text file name (defaults to 'input.txt')" do |s|
    options[:file] = f
  end

  opts.on "-h", "--help", "Shows usage" do
    warn opts
    exit
  end
end.parse!

Charger::Parser.new(options[:file]).render
