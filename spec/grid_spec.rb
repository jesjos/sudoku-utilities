require 'spec_helper'

describe Sudoku::Grid do
  let(:grid) { Sudoku::Grid.new }
  let(:filled_grid) { Sudoku::Grid.parse(Array.new(9, "123456789").join("\n"))}
  
  describe ".rows" do
    it "returns an array of 9 arrays" do
      grid.rows.size.should eq(9)
      grid.rows.each {|row| row.size.should eq(9)}
    end
    it "returns an array of arrays of cells" do
      grid.rows.each {|row| row.each {|cell| cell.should be_a Sudoku::Cell }}
    end
  end

  describe ".columns" do
    it "returns an array of 9 arrays" do
      grid.columns.size.should eq(9)
      grid.columns.each {|column| column.size.should eq(9)}
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
        grid = Sudoku::Grid.new
        grid.cells.each {|cell| cell.value = 1}
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

  describe ".clone" do
    it "returns a grid with the same values but with different object_ids" do
      other = filled_grid.clone
      other.cells.map(&:object_id).should_not eq(filled_grid.cells.map(&:object_id))
      other.cells.map(&:value).should eq(filled_grid.cells.map(&:value))
    end
  end

  describe ".regions" do
    it "creates 27 regions" do
      grid.regions.size.should eq(3*9)
    end
  end
end