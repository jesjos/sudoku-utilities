module Sudoku
  class Solver

    def set_next_value(grid)
      cell = next_cell_to_set(grid)
      puts "setting next value for cell with possible values #{cell.possible_values}"
      return false if cell.possible_values.empty?
      cell.value = cell.possible_values.first
    end

    def next_cell_to_set(grid)
      sorted = empty_cells.sort do |one, other|
        one.possible_values.size <=> other.possible_values.size
      end
      sorted.first
    end

    def solve(grid)
      set_possible_values(grid)
      cells = grid.empty_cells.sort do |one, other| 
        one.possible_values.size <=> other.possible_values.size
      end
      cells = Hamster.list(*cells)
      _solve(grid, cells)
    end

    def _solve(grid)
      return true if solved?(grid)
      grid.empty_cells.each_with_index do |cell|

      end
    end

    def solve_for_grid_and_cell(grid, cell)
      return if solved?
      cell.possible_values.any? do |value|
      end
    end

    def set_possible_values(grid)
      grid.regions.each &:set_possible_values
    end

    def solved?(grid)
      grid.regions.all? {|region| region.complete? }
    end
  end
end