module Sudoku
  class DifficultyAnalyzer

    attr_reader :grid

    def initialize(grid)
      @grid = grid
    end

    def given_values_count
      grid.values.select {|key, possible_values| set?(possible_values) }.size
    end

    def set?(possible_values)
      possible_values.size == 1
    end

    def difficulty
      if score > 30
        "easy"
      elsif score > 26
        "medium"
      elsif score > 24
        "hard"
      else 
        "samuraj"
      end
    end

    def score
      given_values_count
    end
  end
end