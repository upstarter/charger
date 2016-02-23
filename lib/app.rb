require "optparse"
require 'byebug'
require_relative "supervisor"
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #$0 -f file"

  opts.on "-f", "--file FILENAME", "Input text file name (defaults to 'input.txt')" do |s|
    options[:file] = s
  end

  opts.on "-h", "--help", "Shows usage" do
    warn opts
    exit
  end
end.parse!

supervisor = Charger::Supervisor.new(input: options[:file])
supervisor.extract
supervisor.draw
