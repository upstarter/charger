require 'money'
Money.use_i18n = false

require_relative "../../../lib/charger/transaction"

describe Charger::Transaction do
  let(:filename) { "input.txt" }
  let(:expected_data) do
    [
      ["Tom", "$500.00"],
      ["Lisa", "$-93.00"],
      ["Quincy", "error"]
    ]
  end

  subject { described_class.new(filename) }

  it "#process returns data rows" do
    expect(subject.process).to eq(expected_data)
  end

end