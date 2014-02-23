module Sudoku
  class Solver

    attr_reader :grid, :callback, :solved_grids, :visited_grids

    def initialize(grid, &block)
      @grid = grid
      @callback = block
      @visited_grids = {}
      @solved_grids = []
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
      if unsolvable?(grid) || visited?(grid)
        false
      end
      visit(grid)
      if solved? grid
        solved_grids << grid
        grid
      else
        grid.cells_by_number_of_possible_values.each do |cell|
          cell.possible_values.each do |value|
            new_grid = cell.set(value)
            callback.call(new_grid) if callback
            solve_grid(new_grid)
          end
        end
      end
    end

    def visit(grid)
      visited_grids[grid.to_s] = true
    end

    def visited?(grid)
      visited_grids.has_key? grid.to_s
    end

    def solved?(grid)
      grid.regions.all? {|region| region.complete? }
    end

    def unsolvable?(grid)
      grid.cells.any? {|cell| cell.empty? && cell.no_possible_values? }
    end

    def benchmark
      @started_at = Time.now
      result = yield
      @stopped_at = Time.now
      result
    end
  end
end