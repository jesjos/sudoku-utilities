module Sudoku
  class Generator
    include PeersAndUnits

    attr_reader :difficulty_analyzer

    def initialize
      @gaussian_generator = Distribution::Normal.rng(4.5, 3)
      @difficulty_analyzer = DifficultyAnalyzer.new
    end

    def generate(difficulty = "easy")
      grid = start_grid
      keys = randomized_keys
      while !correct_difficulty?(difficulty, grid) do
        key = keys.shift
        grid.reset(key)
        while !uniquely_solvable?(grid)
          key = keys.shift
          new_grid = grid.reset(key)
        end
      end
    end

    def uniquely_solvable?(grid)
      solver = Solver.new(grid.to_propagating_grid)
      solver.solve && solver.unique_solution?
    end

    def randomized_keys
      keys = SORTED_KEYS.to_set
      output = Set.new
      while keys.any? do
        random_key = gaussian_random_key
      end
    end

    def correct_difficulty?(difficulty, grid)
      difficulty_analyzer.grid = grid
      difficulty_analyzer.difficulty == difficulty
    end

    def start_grid
      solve(seed.to_propagating_grid)
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

    def gaussian_random_row
      n = gaussian_random - 1
      ROW_KEYS[n]
    end

    # returns a normally distributed random value between 1 and 9
    def gaussian_random
      value = raw_gaussian_value
      while !valid_value? value
        value = raw_gaussian_value
      end
      value
    end

    def gaussian_random_key
      "#{gaussian_random_row}#{gaussian_random}"
    end

    def valid_value?(n)
      n > 0 && n < 10
    end

    def raw_gaussian_value
      @gaussian_generator.call.round
    end
  end
end