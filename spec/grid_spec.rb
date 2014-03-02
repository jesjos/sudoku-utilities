require 'spec_helper'

describe Sudoku::Grid do
  let(:grid) { Sudoku::Grid.new }
  describe ".values" do
    it "is a hash" do
      grid.values.should respond_to(:keys)
    end

    describe ".keys" do
      it "returns all the needed keys" do
        keys = ("A".."I").map {|col| (1..9).map {|row| "#{col}#{row}"}}
        Set.new(grid.values.keys.to_a.flatten).should eq(Set.new(keys.flatten))
      end
    end
  end

  describe ".column_keys" do
    it "returns numbers 1 to 9" do
      grid.column_keys.should eq((1..9).to_a)
    end
  end

  describe ".row_keys" do
    it "returns the letters a to i" do
      grid.row_keys.should eq(("A".."I").to_a)
    end
  end

  describe ".to_s" do
    context "when given an empty sudoku" do
      it "returns 9x9 string of dots" do
        empty_sudoku = Array.new(9, Array.new(9, ".").join).join "\n"
        grid.to_s.should eq(empty_sudoku)
      end
    end
  end

  describe ".to_s_cell" do
    context "when the cell hasn't been set" do
      it "returns a dot" do
        grid.to_s_cell([1,2,3]).should eq(".")
      end
    end

    context "when the cell has been set" do
      it "returns the cell's value" do
        grid.to_s_cell([1]).should eq("1")
      end
    end
  end


  describe ".extract_row" do
    it "returns the first character of the key" do
      grid.extract_row("A1").should eq("A")
    end
  end

  describe ".extract_column" do
    it "returns the second character of the key" do
      grid.extract_column("A1").should eq("1")
    end
  end

  describe ".eliminate_from_peers_of" do
    it "eliminates the value from all peers" do
      grid.eliminate_from_peers_of("A1", 1)
      grid.peer_keys("A1").each do |key|
        Set.new(grid.values[key].to_a).should eq(Set.new(2.upto(9).to_a))
      end
    end

    it "returns false if trying to eliminate a square with only one possible value" do
      grid.values = grid.values.put "A1", Hamster.set(1)
      grid.eliminate_from_peers_of("A2", 1).should be_false
    end

    it "returns true if elimination succeeded" do
      grid.eliminate_from_peers_of("A1", 1).should be_true
    end

    it "propagates the elimination" do
      grid.values = grid.values.put "A1", Hamster.set(1,2)
      grid.values = grid.values.put "A2", Hamster.set(1,2)
      grid.values = grid.values.put "A3", Hamster.set(2,3)
      grid.eliminate_from_peers_of("A1", 1)
      grid.values["A3"].should eq(Hamster.set(3))
    end
  end

  describe ".new" do
    context "when given another grid" do
      it "creates a copy with the same values" do
        grid2 = Sudoku::Grid.new(grid)
        grid2.values.should eq(grid.values)
        grid2.set("A1", 1)
        grid2.values["A1"].should_not eq(grid.values["A1"])
      end
    end
  end

  describe ".empty_values" do
    it "returns all values that have a length larger than 1" do
      grid.set("A1", 1)
      grid.empty_values.size.should eq(80)
      Set.new(grid.empty_values.keys).should eq(Set.new(grid.sorted_keys - ["A1"]))
    end
  end

  describe ".sorted_empty_values" do
    it "returns square with the least empty values first" do
      grid.set("A1", 1)
      tuple = grid.sorted_empty_values.first
      tuple.last.size.should eq(8)
      grid.set("A2", 2)
      tuple = grid.sorted_empty_values.first
      tuple.last.size.should eq(7)      
    end
  end

  describe ".peers" do
    it "returns an array of length 20" do
      Sudoku::Grid::SORTED_KEYS.each do |key|
        grid.peer_keys(key).size.should eq(20)
      end   
    end
  end

  describe ".units_containing" do
    it "returns three units for each key" do
      Sudoku::Grid::SORTED_KEYS.each do |key|
        grid.units_containing(key).size.should eq(3)
      end
    end

    it "returns the correct units for a random key" do
      row = (1..9).map {|column| "C#{column}"}
      column = ("A".."I").map {|row| "#{row}7"}
      box = ("A".."C").to_a.product((7..9).to_a).map {|(row, column)| "#{row}#{column}"}
      [row, column, box].each do |unit|
        grid.units_containing("C7").should include(unit)
      end
    end
  end

  describe ".eliminate_unitwise" do

    it "" do
      
    end
  end

  describe ".eliminate_single_occurrence" do
    context "when there is only one possible place left for a value" do
      it "eliminates those values from the other squares" do
        grid.values = grid.values.put "A1", Hamster.set(*[1,2])
        row = Sudoku::Grid::ROW_UNITS.first
        other_keys = row - ["A1"]
        other_keys.each {|key| grid.values = grid.values.put key, Hamster.set(*[3,4,5,6,7,8,9]) }
        grid.eliminate_single_occurrence("A1", 2).should eq(true)
        grid.values["A1"].should eq(Hamster.set(2))
      end
    end
  end

end