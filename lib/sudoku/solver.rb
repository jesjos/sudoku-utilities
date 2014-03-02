module Sudoku
  class Solver

    attr_reader :grid, :callback, :solved_grids, :visited_grids

    def initialize(grid)
      @grid = grid
      @solved_grids = []
      @visited_grids = Set.new
      @skipped = 0
    end

    def solve(&block)
      @callback = block
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
      visit(grid)
      if solved?(grid)
        solved_grids << grid
        return true
      end
      return false if unsolvable? grid
      grid.sorted_empty_values.each do |(key, values)|
        values.each do |value|
          new_grid = grid.clone
          if new_grid.set(key, value)
            solve_grid(new_grid) 
          else 
            @skipped += 1
          end
          callback("Visiting: \n" + grid.to_s + "\nSolved: #{solved_grids.size} grids\n, Visited #{@visited_grids.size} grids \n#{grid.values_to_s}\nSkipped: #{@skipped}")
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

    def unique_solution?
      solved_grids.size == 1      
    end
    
    def benchmark
      @started_at = Time.now
      result = yield
      @stopped_at = Time.now
      result
    end

    def callback(input)
      if @callback
        @callback.call(input)
      end
    end
  end
end