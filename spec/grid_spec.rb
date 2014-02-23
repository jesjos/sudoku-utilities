require 'spec_helper'

describe Sudoku::Grid do
  let(:grid) { Sudoku::Grid.new }
  let(:filled_grid) { Sudoku::Grid.parse(Array.new(9, "123456789").join("\n"))}
  
  describe ".rows" do
    it "returns an array of 9 vectors" do
      grid.rows.size.should eq(9)
      grid.rows.each {|row| row.size.should eq(9)}
    end
    it "returns an array of arrays of integers" do
      grid.rows.each {|row| row.each {|cell| cell.should be_a Integer }}
    end
  end

  describe ".columns" do
    it "returns an array of 9 arrays" do
      grid.columns.size.should eq(9)
      grid.columns.each {|column| column.size.should eq(9)}
    end

    it "returns an array where the rows are columns" do
      filled_grid.columns.each_with_index.all? do |row,i| 
        row.all? {|cell| cell.value.should eq(i + 1) }
      end
    end
  end

  describe ".to_s" do
    context "when the grid is empty" do
      it "returns a pretty string" do
        string = Array.new(9, ".........").join("\n")
        grid.to_s.should eq(string)
      end
    end

    context "when the grid has some actual cells" do
      it "returns a pretty string" do
        grid = Sudoku::Grid.new(1)
        output = Array.new(9, Array.new(9, "1").join).join("\n")
        grid.to_s.should eq(output)
      end      
    end

    describe "two-way" do
      it "returns the same string" do
        input = Array.new(9, "123456789").join("\n")
        grid = Sudoku::Grid.parse(input)
        grid.to_s.should eq(input)
      end
    end
  end

  describe ".cells" do
    it "returns a big array of cells" do
      grid.cells.size.should eq(9*9)
    end
  end

  describe ".cell_rows" do
    it "returns an array of arrays of cells" do
      grid.cell_rows.all? {|row| row.all? {|cell| cell.is_a? Sudoku::Cell}}
    end
  end

  describe ".quadrants" do
    let(:quadrants) do
      base = [
        [1,2,3,1,2,3,1,2,3].map(&:to_s),
        [4,5,6,4,5,6,4,5,6].map(&:to_s),
        [7,8,9,7,8,9,7,8,9].map(&:to_s)
      ]
      base = base + base + base
    end
    it "returns correct quadrants" do
      quadrant_values = filled_grid.quadrants.map{|quadrant| quadrant.map &:to_s }
      (quadrant_values - quadrants).should be_empty
    end

    it "returns the correct number of quadrants" do
      grid.quadrants.size.should eq(9)
    end
  end

  describe ".regions" do
    it "creates 27 regions" do
      grid.regions.size.should eq(3*9)
    end
  end

  describe ".set" do
    it "returns a new grid" do
      grid2 = grid.set(row: 0, column: 0, value: 1)
      grid2.should_not eq(grid)
    end

    it "returns a grid where the cell is set" do
      grid2 = grid.set(row: 0, column: 0, value: 1)
      grid2.rows.get(0).get(0).should eq(1)
    end
  end

  describe ".get" do
    it "returns a value at a particular cell" do
      grid.get(0,0).should eq(0)
      grid2 = grid.set(row: 0, column: 0, value: 1)
      grid2.get(0,0).should eq(1)
    end
  end
end