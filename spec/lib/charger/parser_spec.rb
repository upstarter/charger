require_relative "../../../lib/charger/parser"

describe Charger::Parser do
  let(:expected_data) do
    [
      ["Name", "Balance"],
      ["Tom", "$500.00"],
      ["Lisa", "$-93.00"],
      ["Quincy", "error"]
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
