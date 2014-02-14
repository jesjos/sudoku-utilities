module Sudoku
  class Solver

    attr_reader :grid

    def initialize(grid)
      @grid = grid
    end

    def regions
      @regions ||= column_regions + row_regions + quadrant_regions
    end

    def column_regions
      @column_regions ||= grid.columns.map {|column| Sudoku::Region.new(column)}
    end

    def row_regions
      @row_regions ||= grid.rows.map {|row| Sudoku::Region.new(row)}
    end

    def quadrant_regions
      @quadrant_regions ||= grid.quadrants.map {|quadrant| Sudoku::Region.new(quadrant)}
    end

    def solve
      set_possible_values
      while !solved?
        set_next_value
        set_possible_values
      end
    end

    def set_possible_values
      regions.each &:set_possible_values
    end

    def solved?
      
    end
  end
end