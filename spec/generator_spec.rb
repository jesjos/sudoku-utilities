require 'spec_helper'

describe Sudoku::Generator do
  let(:gen) { Sudoku::Generator.new }
  let(:medium) { Sudoku::Grid.parse(File.open("./spec/test_grids/medium.txt").read, Sudoku::NonPropagatingGrid) }
  describe ".seed" do
    it "creates a grid with a single random square set" do
      grid = gen.seed
      grid.empty_values.size.should eq (80)
    end
  end

  describe ".random_key" do
    it "returns a valid key" do
      100.times { Sudoku::PeersAndUnits::SORTED_KEYS.should include(gen.linear_random_key) }
    end
  end

  describe ".random_value" do
    it "returns an integer between 1 and 9" do
      100.times do
        n = gen.linear_random
        n.should be > 0
        n.should be < 10
      end
    end
  end

  describe ".start_grid" do
    it "returns a completely filled grid" do
      grid = gen.start_grid
      grid.empty_values.should be_empty
    end
  end

  describe ".uniquely_solvable?" do
    it "returns true for a known uniquely solvable grid" do
      gen.uniquely_solvable?(medium).should eq(true)
    end
  end

  describe ".correct_difficulty?" do
    it "returns true if the difficulty matches" do
      gen.correct_difficulty?("medium", medium)
    end

    it "return false if the difficulties do not match" do
      gen.correct_difficulty?("easy", medium)
    end
  end

  # describe ".generate" do
  #   let(:analyzer) { Sudoku::DifficultyAnalyzer.new }
  #   ["easy", "medium", "hard", "samuraj"].each do |diff|
  #     it "returns a grid of the correct difficulty" do
  #       grid = gen.generate(diff)
  #       analyzer.grid = grid
  #       analyzer.difficulty.should eq diff
  #     end
  #   end
  # end

  describe ".randomized_keys" do
    it "returns all keys" do
      gen.randomized_keys.to_set.should eq Sudoku::PeersAndUnits::SORTED_KEYS.to_set
    end
  end
end