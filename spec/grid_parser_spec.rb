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
    it "returns an array of integers" do
      string = "123456789\n123456789"
      values = parser.parse_string(string)
      values.should eq((1..9).to_a + (1..9).to_a)
    end
  end
end