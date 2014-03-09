require 'spec_helper'

describe Sudoku::GridParser do
  let(:parser) { Sudoku::GridParser.new }
  let(:cell_row) { cells = 1.upto(9).to_a }
  describe ".parse_line" do
    it "returns an array of integers" do
      parsed_cells = parser.parse_line("123456789")
      parsed_cells.should eq(cell_row)
    end
  end

  describe ".parse_string" do
    let(:output) { Array.new(9, (1..9).to_a).flatten }
    it "returns an array of integers" do
      string = Array.new(9, "123456789").join("\n")
      values = parser.parse_string(string)
      values.should eq(output)
    end

    it "handles \\n and \\r" do
      string = Array.new(9, (1..9).to_a.join).join("\r\n")
      values = parser.parse_string(string)
      values.should eq(output)
    end
  end
end