module Sudoku
  class Generator
    include PeersAndUnits

    VALID_DIFFICULTIES = ["easy", "medium", "hard", "samuraj"]

    attr_reader :difficulty_analyzer

    def initialize
      @difficulty_analyzer = DifficultyAnalyzer.new
    end

    def generate(difficulty = "easy")
      check_difficulty!(difficulty)
      grid = start_grid
      keys = Hamster.list(randomized_keys)
      search(grid, difficulty, keys)
    end

    def check_difficulty!(difficulty)
      raise "Invalid difficulty" unless VALID_DIFFICULTIES.include?(difficulty)
    end

    def search(grid, difficulty, keys)
      raise "Could not generate a grid" if keys.empty?
      return grid if done_generating?(grid, difficulty)
      keys.reduce(nil) do |found_grid, key|
        new_grid = grid.clone
        new_grid.reset(key)
        if uniquely_solvable? new_grid
          new_keys = Hamster.list(*new_grid.assigned_keys.to_a.shuffle)
          return search(new_grid, difficulty, new_keys)
        else
          return false
        end
      end
    end

    def done_generating?(grid, difficulty)
      enough_empty_squares?(grid) && correct_difficulty?(difficulty, grid) && uniquely_solvable?(grid)
    end

    def enough_empty_squares?(grid)
      grid.empty_values.size > 40
    end

    def uniquely_solvable?(grid)
      solver = Solver.new(grid.to_propagating_grid)
      solver.solve && solver.unique_solution?
    end

    def randomized_keys
      keys = SORTED_KEYS.clone
      keys.shuffle
    end

    def correct_difficulty?(difficulty, grid)
      difficulty_analyzer.grid = grid
      difficulty_analyzer.difficulty == difficulty
    end

    def start_grid
      solve(seed).to_non_propagating_grid
    end

    def solve(grid)
      solver = Solver.new(grid)
      solver.solve(check_uniqueness: false)
      solver.solution
    end

    def seed
      grid = NonPropagatingGrid.new
      grid.set(linear_random_key, linear_random)
      grid
    end

    def linear_random_key
      ROW_KEYS[linear_random] + linear_random.to_s
    end

    def linear_random
      rand(8) + 1
    end
  end
end