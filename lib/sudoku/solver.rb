module Sudoku
  class Solver

    attr_reader :grid, :callback

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
      grid.set_possible_values
      return false if unsolvable? grid
      return grid if solved? grid
      grid.cells_by_number_of_possible_values.find do |cell|
        cell.possible_values.find do |value|
          new_grid = cell.set(value)
          callback.call(new_grid) if callback
          @solved_grid = solve_grid(new_grid)
        end
      end
      @solved_grid
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