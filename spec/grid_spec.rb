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

end