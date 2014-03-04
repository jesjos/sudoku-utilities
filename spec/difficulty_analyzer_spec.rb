require 'spec_helper'

describe Sudoku::DifficultyAnalyzer do
  let(:grid) { Sudoku::NonPropagatingGrid.new}

  describe ".given_values_count" do
    context "when no values are set" do
      it "returns 0" do
        analyzer = a(grid)
        analyzer.given_values_count.should eq(0)
      end      
    end

    context "when values are set" do
      it "returns the count of them" do
        analyzer = a(grid)
        grid.set("A1", 1)
        analyzer.given_values_count.should eq(1)
      end
    end
  end

  describe ".difficulty" do
    let(:easy) { Sudoku::Grid.parse(File.open("./spec/test_grids/basic.txt").read, Sudoku::NonPropagatingGrid) }
    let(:medium) { Sudoku::Grid.parse(File.open("./spec/test_grids/medium.txt").read, Sudoku::NonPropagatingGrid) }
    let(:hard) { Sudoku::Grid.parse(File.open("./spec/test_grids/hard.txt").read, Sudoku::NonPropagatingGrid) }
    let(:samuraj) { Sudoku::Grid.parse(File.open("./spec/test_grids/samuraj.txt").read, Sudoku::NonPropagatingGrid) }

    context "when given basic grid" do
      it "returns easy" do
        analyzer = a(easy)
        analyzer.difficulty.should eq("easy")
      end
    end

    context "when given medium grid" do
      it "returns medium" do
        analyzer = a(medium)
        analyzer.difficulty.should eq("medium")        
      end
    end

    context "when given hard grid" do
      it "returns hard" do
        analyzer = a(hard)
        analyzer.difficulty.should eq("hard")
      end
    end

    context "when given hard grid" do
      it "returns hard" do
        analyzer = a(samuraj)
        analyzer.difficulty.should eq("samuraj")
      end
    end
  end

  def a(grid)
    Sudoku::DifficultyAnalyzer.new(grid)
  end
end