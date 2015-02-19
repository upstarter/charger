require_relative "../../../lib/charger/parser"

describe Charger::Parser do
  let(:expected_data) do
    [
      ["Name", "Card", "Balance"],
      ["Tom", "4111111111111111", "$500.00"],
      ["Lisa", "5454545454545454", "$-93.00"],
      ["Quincy", "1234567890123456", "error"]
    ]
  end
  subject { described_class.new }

  it "invokes table render" do
    expect(Charger::SummaryTable).to receive(:draw).with(subject.data)
    subject.render
  end

  context "with user specified file" do
    subject { described_class.new "input.txt" }
    it "generates summary given the user's input" do
      expect(subject.data).to eq(expected_data)
    end
  end
end
