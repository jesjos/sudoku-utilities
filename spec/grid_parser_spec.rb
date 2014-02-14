require 'spec_helper'

describe Sudoku::GridParser do
  let(:parser) { Sudoku::GridParser.new("apa")}
  let(:cell_row) { cells = 1.upto(9).map {|i| Sudoku::Cell.new(i)} }
  describe ".parse_line" do
    it "returns an array of cells" do
      parsed_cells = parser.parse_line("123456789")
      cell_row.zip(parsed_cells).each do |(one, other)|
        one.should eql(other)
      end
    end
  end

  describe ".parse_string" do
    it "returns an array of arrays of cells" do
      string = "123456789\n123456789"
      parsed_cells = parser.parse_string(string)
      parsed_cells.each do |row|
        cell_row.zip(row).each do |(one, other)|
          one.should eql(other)
        end
      end
    end
  end
end