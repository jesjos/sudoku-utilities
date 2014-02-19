require "spec_helper"

describe Sudoku::Solver do
  let(:grid) { Sudoku::Grid.new}
  
  describe ".set_possible_values" do
    it "calls .set_possible_values on each region" do
      solver = Sudoku::Solver.new(grid)
      solver.regions.each do |region|
        expect(region).to receive(:set_possible_values).once
      end
      solver.set_possible_values
    end
  end

  describe ".next_cell_to_set" do
    it "returns the cell with the smallest number of possible values" do
      grid.cells.first.possible_values = [1]
      solver = Sudoku::Solver.new(grid)
      solver.next_cell_to_set.should eq(grid.cells.first)
    end
  end

  describe ".set_next_value" do
    it "sets the cell's value to the first possible value" do
      grid.cells.first.possible_values = [1,2]
      solver = Sudoku::Solver.new(grid)
      solver.set_next_value
      grid.cells.first.value.should eq(1)
    end
  end

  describe ".solved?" do
    it "is true if all regions are valid and all cells have values" do
      Sudoku::Region.any_instance.stub(:complete?).and_return(true)
      solver = Sudoku::Solver.new(grid)
      solver.solved?.should be_true
    end
  end
end