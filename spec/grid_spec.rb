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

  describe ".row_peer_keys" do
    it "returns the correct row keys" do
      keys = 2.upto(9).map {|n| "A#{n}"}
      grid.row_peer_keys("A1").should eq(keys)
    end
  end

  describe ".column_peer_keys" do
    it "returns the set of keys" do
      keys = "B".upto("I").map {|c| "#{c}1"}
      grid.column_peer_keys("A1").should eq(keys)
    end
  end

  describe ".box_peer_keys" do
    it "returns the correct set of keys" do
      keys = ["A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"]
      grid.box_peer_keys("A1").should eq(keys)
      keys = ["G1", "G3", "H1", "H2", "H3", "I1", "I2", "I3"]
      grid.box_peer_keys("G2").should eq(keys)
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

  describe ".box_row_keys" do
    context "when given a letter in an interval" do
      [("A".."C"), ("D".. "F"), ("G".."I")].each do |interval|
        it "returns that interval" do
          interval.each do |letter|
            grid.box_row_keys("#{letter}1").should eq(interval.to_a)
          end
        end
      end
    end
  end

  describe ".box_column_keys" do
    context "when given a letter in an interval" do
      [(1..3), (4..6), (7..9)].each do |interval|
        it "returns that interval" do
          interval.each do |number|
            grid.box_column_keys("A#{number}").should eq(interval.to_a)
          end
        end
      end
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

end