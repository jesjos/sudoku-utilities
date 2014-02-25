module Sudoku
  class Solver

    attr_reader :grid, :callback, :solved_grids, :visited_grids

    def initialize(grid, &block)
      @grid = grid
      @callback = block
    end

    def solve
      result = benchmark do
        solve_grid(grid)
      end
    end

    def total_time
      @stopped_at - @started_at
    end

    def solve_grid(grid)
      if solved?(grid)
        solved_grids << grid
        return true
      end
      return false if unsolvable? grid
      grid.empty_values.each do |key, values|
        new_grid = grid.clone
        values.each do |value|
          new_grid.set(key, value)
          solve_grid(grid)
        end
      end
    end

    def unsolvable?(grid)
      grid.values.any? {|k,value| value.empty?}
    end

    def solved?(grid)
      grid.values.all? {|key, value| value.size == 1 }
    end
    
    def benchmark
      @started_at = Time.now
      result = yield
      @stopped_at = Time.now
      result
    end
  end
end