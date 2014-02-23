require "spec_helper"

describe Sudoku::Solver do
  let(:grid) { Sudoku::Grid.new}

  describe ".solved?" do
    it "is true if all regions are valid and all cells have values" do
      Sudoku::Region.any_instance.stub(:complete?).and_return(true)
      solver = Sudoku::Solver.new(grid)
      solver.solved?(grid).should be_true
    end
  end
end