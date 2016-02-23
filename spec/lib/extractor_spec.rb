require_relative "../../lib/extractor"
require_relative "../../lib/supervisor"

describe Charger::Extractor do
  let(:file) { "input.txt" }
  let(:supervisor) { Charger::Supervisor.new(input: file) }

  let(:expected_data) do
    "   Name  Balance  \n    Tom: $500.00  \n   Lisa: $-93.00  \n Quincy:   error  \n"
  end

  subject { described_class.new(input: input, supervisor: supervisor) }

  context "File" do
    let(:input) { file }
    it "reads from file" do
      expect(subject).to receive(:take_file)
      subject.extract
    end
  end

  context "STDIN" do
    let(:results) { `ruby lib/app.rb < input.txt` }
    let(:input) { nil }

    it "reads from stdin" do
      expect(results).to eq(expected_data)
    end
  end
end
