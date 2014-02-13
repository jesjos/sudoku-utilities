require 'spec_helper'

describe Sudoku::Grid do
  let(:grid) { Sudoku::Grid.new }
  describe ".rows" do
    it "returns an array of 9 arrays" do
      grid.rows.size.should eq(9)
      grid.rows.each {|row| row.size.should eq(9)}
    end
  end
  describe "#parse" do

  end
end