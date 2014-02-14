require 'spec_helper'

describe Sudoku::Grid do
  let(:grid) { Sudoku::Grid.new }
  
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
    it "returns a pretty string" do
      string = Array.new(9, ".........").join("\n")
      grid.to_s.should eq(string)
    end
  end

  describe ".cells" do
    it "returns a big array of cells" do
      grid.cells.size.should eq(9*9)
    end
  end
end