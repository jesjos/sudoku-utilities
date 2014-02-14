require 'spec_helper'

describe Sudoku::Region do
  let(:full) { Sudoku::Region.new 1.upto(9).map {|n| Sudoku::Cell.new(n)} }
  describe ".valid?" do
    context "when no number 1-9 occurs more than once" do
      it "returns true" do
        cells = 1.upto(9).map {|n| Sudoku::Cell.new(n) }
        region = Sudoku::Region.new cells
        region.valid?.should eq(true)        
      end
    end
  end

  describe ".non_empty_cell_values" do
    it "only returns non-empty cell values" do
      region = Sudoku::Region.new [Sudoku::Cell.new(1), Sudoku::Cell.new]
      region.non_empty_cell_values.should eq([1])
    end
  end

  describe ".complete?" do
    context "when all cells are filled and valid" do
      it "is true" do
        region = full
        region.should be_complete
      end
    end
  end

  describe ".filled?" do
    context "when all cells are filled" do
      it "is true" do
        region = full
        region.should be_filled
      end
    end
    context "when there are empty cells" do
      it "is false" do
        region = full
        region.cells.first.value = 0
        region.should_not be_filled
      end
    end
  end

  describe ".set_possible_values" do
    it "sets the possible values of all empty cells" do
      cells = 1.upto(7).map {|n| Sudoku::Cell.new(n)}
      cells += [Sudoku::Cell.new, Sudoku::Cell.new]
      region = Sudoku::Region.new(cells)
      region.set_possible_values
      region.empty_cells.each do |cell|
        cell.possible_values.should eq([8,9])
      end
    end
  end

  describe ".unused_values" do
    it "returns the values not yet occupied" do
      cells = 1.upto(7).map {|n| Sudoku::Cell.new(n)}
      cells += [Sudoku::Cell.new, Sudoku::Cell.new]
      region = Sudoku::Region.new(cells)
      region.unused_values.should eq([8,9])
    end
  end
end