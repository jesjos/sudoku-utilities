require 'spec_helper'

describe Sudoku::GridParser do
  let(:parser) { Sudoku::GridParser.new }
  let(:cell_row) { cells = 1.upto(9).to_a }
  describe ".parse_line" do
    it "returns an array of cells" do
      parsed_cells = parser.parse_line_with_number("123456789", 1)
      cell_row.zip(parsed_cells).each do |(one, other)|
        one.should eql(other)
      end
    end
  end

  describe ".parse_string" do
    it "returns grid" do
      string = "123456789\n123456789"
      grid = parser.parse_string(string)
      grid.rows.each do |row|
        cell_row.zip(row).each do |(one, other)|
          one.should eql(other)
        end
      end
    end
  end
end