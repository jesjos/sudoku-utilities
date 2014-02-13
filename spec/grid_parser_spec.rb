require 'spec_helper'

describe Sudoku::GridParser do
  let(:parser) { Sudoku::GridParser.new("apa")}
  describe ".parse_line" do
    it "returns an array of cells" do
      cells = 1.upto(9).map {|i| Sudoku::Cell.new(i)}
      parsed_cells = parser.parse_line("123456789")
      cells.zip(parsed_cells).each do |(one, other)|
        one.should eql(other)
      end
    end
  end
end