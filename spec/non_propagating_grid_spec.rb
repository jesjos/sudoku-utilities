require 'spec_helper'

describe Sudoku::NonPropagatingGrid do
  let(:grid) { Sudoku::NonPropagatingGrid.new }

  describe ".set" do
    it "doesn't propagate" do
      grid.set("A1", 1)
      grid.values["A1"].size.should eq(1)
      grid.values.all? {|key, value| key == "A1" || value.size == 9}.should be_true
    end
  end

  describe ".reset" do
    it "sets the square to all possible values" do
      grid.set("A1", 1)
      grid.reset("A1")
      grid.values["A1"].size.should eq(9)
    end
  end

end