require 'spec_helper'

describe Sudoku::Cell do
  let(:cell) { Sudoku::Cell.new }
  let(:one_cell) { Sudoku::Cell.new(1) }

  describe ".initialize" do
    context "when given no argument" do
      it "sets the value to zero" do
        cell.value.should eq(0)
      end      
    end
    context "when given an integer" do
      it "sets the value as expected" do
        Sudoku::Cell.new(1).value.should eq(1)
      end
    end
  end
  describe ".empty?" do
    it "returns true if the value is 0" do
      cell.should be_empty
    end

    it "return false if the value is non-zero" do
      one_cell.should_not be_empty
    end
  end

  describe ".value=" do
    it "raises an error for numbers smaller than 0 and larger than 9" do
      -> { cell.value = -1}.should raise_error  
      -> { cell.value = 10}.should raise_error
    end
  end

  describe ".sane?" do
    context "when given nil" do
      it "is true" do
        Sudoku::Cell.new.sane?(nil).should be_true
      end
    end
    context "when given an integer between 1 and 9" do
      it "is true" do
        1.upto(9) {|n| Sudoku::Cell.new.sane?(n).should be_true }
      end
    end
    context "when given some random thing" do
      it "is false" do
        Sudoku::Cell.new.sane?(-10).should be_false
      end
    end
  end

  describe ".eql?" do
    context "when two cells have the same value" do
      it "is true" do
        one_cell.should eql(Sudoku::Cell.new(1))
      end
    end
    context "when two cells have different values" do
      it "is false" do
        cell.should_not eql(one_cell)
      end
    end
  end

  describe "#parse" do
    context "when given an integer between 1 and 9" do
      it "returns a cell with that value" do
        1.upto(9) do |n|
          Sudoku::Cell.parse(n.to_s).should eql(Sudoku::Cell.new(n))
        end
      end
    end
    context "when given anything else" do
      it "returns a zero cell" do
        [0, "x", "f"].each do |thing|
          Sudoku::Cell.parse(thing).should eql(Sudoku::Cell.new(0))
        end
      end
    end
  end

  describe ".to_s" do
    context "when the value is not 0" do
      it "it returns the value" do
        1.upto(9) do |n|
          Sudoku::Cell.new(n).to_s.should eq(n.to_s)
        end 
      end
    end

    context "when the value is 0" do
      it "returns a dot" do
        Sudoku::Cell.new(0).to_s.should eq(".")
      end
    end
  end

  describe ".possible_values" do
    context "when created empty" do
      it "is populated with values 1 to 9" do
        cell.possible_values.should eq((1..9).to_a)
      end
    end
  end



end