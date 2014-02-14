require "spec_helper"

describe Sudoku::Solver do
  let(:grid) { Sudoku::Grid.new}
  describe ".regions" do
    it "creates 27 regions" do
      solver = Sudoku::Solver.new(grid)
      solver.regions.size.should eq(3*9)
    end
  end

  describe ".set_possible_values" do
    it "calls .set_possible_values on each region" do
      solver = Sudoku::Solver.new(grid)
      solver.regions.each do |region|
        expect(region).to receive(:set_possible_values).once
      end
      solver.set_possible_values
    end
  end
end