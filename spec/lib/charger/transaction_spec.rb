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

  let(:luhn_data) do
    [
      [49927398716, true],
      [49927398717, false],
      [1234567812345678, false],
      [1234567812345670, true]
    ]
  end

  subject { described_class.new(filename) }

  it "#process returns data rows" do
    expect(subject.process).to eq(expected_data)
  end

  it "validates cards based on luhn 10" do
    luhn_data.each do |data|
      subject.cc_num = data.first.to_s
      expect(subject.send(:luhn_check)).to eq(data.last)
    end
  end

end