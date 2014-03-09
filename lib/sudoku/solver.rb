module Sudoku
  class Solver

    attr_reader :grid, :callback, :solved_grids, :visited_grids

    def initialize(grid)
      @grid = grid.to_propagating_grid
      @solved_grids = []
      @visited_grids = Set.new
      @skipped = 0
    end

    def solution
      solved_grids.first
    end

    def solve(opts = {}, &block)
      defaults = {check_uniqueness: true}
      options = defaults.merge(opts)
      @callback = block
      if opts[:check_uniqueness]
        result = benchmark do
          solve_grid_with_uniqueness(grid)
          solved_grids.any?
        end
      else
        result = benchmark do
          solve_grid(grid)
          solved_grids.length == 1
        end
      end
    end

    def total_time
      @stopped_at - @started_at
    end

    # The each enumerator will enumerate all solutions, which is needed
    # for uniqueness checks
    def solve_grid_with_uniqueness(grid)
      solve_with_enumerator(:each, grid)
    end

    # The any? enumerator will terminate as soon as we find a solution
    def solve_grid(grid)
      solve_with_enumerator(:any?, grid)
    end

    def solve_with_enumerator(enumerator, grid)
      return true if visited? grid
      visit(grid)
      if solved?(grid)
        solved_grids << grid
        return true
      end
      return false if unsolvable? grid
      search_with_enumerator(enumerator, grid)
    end

    def search_with_enumerator(enumerator, grid)
      grid.sorted_empty_values.send(enumerator) do |(key, values)|
        values.send(enumerator) do |value|
          new_grid = grid.clone
          if valid_move = new_grid.set(key, value)
            solve_with_enumerator(enumerator, new_grid) 
          else 
            @skipped += 1
          end
          callback(grid)
          valid_move
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
      grid.values.all? {|key, value| value.size == 1 } && grid.valid?
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

    def callback(grid)
      if @callback
        output = "Visiting: \n" + grid.to_s
        output += "\nSolved: #{solved_grids.size} grids\n,"
        output += "Visited #{@visited_grids.size} grids\n"
        output += "#{grid.values_to_s}\nSkipped: #{@skipped}"
        @callback.call(output)
      end
    end
  end
end