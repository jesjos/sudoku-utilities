require "spec_helper"

describe Sudoku::Solver do
  let(:grid) { Sudoku::Grid.new }

  describe ".solved?" do
    context "when there is only one possible value to each cell" do
      it "is true" do
        values = grid.sorted_keys.reduce({}) {|hash, key| hash[key] = [1]; hash}
        grid.values = Hamster.hash values
        grid.stub(:valid?).and_return(true) # skip validity check...
        solver = Sudoku::Solver.new(grid)
        solver.solved?(grid).should be_true
      end
    end

    context "when there are unfilled cells" do
      it "is false" do
        solver = Sudoku::Solver.new(grid)
        solver.solved?(grid).should_not be_true
      end
    end
  end

  describe ".unsolvable?" do
    context "when there is at least one empty vector" do
      it "is false" do
        grid.values = grid.values.put("A1", Hamster.set)
        solver = Sudoku::Solver.new(grid)
        solver.unsolvable?(grid).should be_true
      end
    end
    context "when there are no empty vectors" do
      it "is true" do
        solver = Sudoku::Solver.new(grid)
        solver.unsolvable?(grid).should be_false
      end
    end
  end

  context "when sudoku is unsolvable" do
    let(:unsolvable_grid) { Sudoku::Grid.parse(File.open("./spec/test_grids/unsolvable.txt").read) }
    describe ".solve" do
      it "returns false" do
        solver = Sudoku::Solver.new(unsolvable_grid)
        solver.solve.should eq(false)
      end
    end
  end
end