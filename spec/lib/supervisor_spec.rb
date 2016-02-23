require_relative "../../lib/supervisor"

describe Charger::Supervisor do
  let(:file) { "input.txt" }
  let(:stdin) { " " }

  let(:expected_data) do
    [
      ["Name", "Balance"],
      ["Tom", "$500.00"],
      ["Lisa", "$-93.00"],
      ["Quincy", "error"]
    ]
  end

  subject { described_class.new(input: file) }

  before { subject.extract }

  it "draws output using a view" do
    expect(Charger::SummaryTable).to receive(:draw).with(subject.data)
    subject.draw
  end

  context "with user specified file" do
    subject { described_class.new(input: "input.txt") }
    it "generates summary given the user's input" do
      expect(subject.data).to eq(expected_data)
    end
  end

  context "with STDIN" do
     it "generates summary given STDIN input" do
      expect(subject.data).to eq(expected_data)
    end
  end
end
