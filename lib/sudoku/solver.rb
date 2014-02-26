module Sudoku
  class Solver

    attr_reader :grid, :callback, :solved_grids, :visited_grids

    def initialize(grid, &block)
      @grid = grid
      @callback = block
      @solved_grids = []
      @visited_grids = Set.new
    end

    def solve
      result = benchmark do
        solve_grid(grid)
        solved_grids.any?
      end
    end

    def total_time
      @stopped_at - @started_at
    end

    def solve_grid(grid)
      return true if visited? grid
      callback.call("Visiting: \n" + grid.to_s + "\nSolved: #{solved_grids.size} grids\n, Visited #{@visited_grids.size} grids \n#{grid.values_to_s}") if callback
      visit(grid)
      if solved?(grid)
        solved_grids << grid
        return true
      end
      return false if unsolvable? grid
      grid.sorted_empty_values.each do |(key, values)|
        values.each do |value|
          new_grid = grid.clone
          solve_grid(new_grid) if new_grid.set(key, value)
        end
      end
    end

    def visit(grid)
      @visited_grids.add(grid)
    end

    def visited?(grid)
      @visited_grids.include? grid
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