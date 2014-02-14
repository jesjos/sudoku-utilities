module Sudoku
  # # Region
  # A region represents a row, a column or a quadrant of the grid
  # i.e. it's a unit that has to be valid
  class Region
    attr_reader :cells
    def initialize(cells)
      @cells = cells
    end

    def valid?
      values = non_empty_cell_values
      Set.new(values).size == values.size
    end

    def non_empty_cell_values
      cells.inject([]) do |non_empty_values, cell|
        return non_empty_values if cell.empty?
        non_empty_values << cell.value
      end
    end

    def complete?
       valid? && filled?
    end

    def set_possible_values
      empty_cells.each do |cell|
        cell.possible_values = unused_values
      end
    end

    def empty_cells
      cells.select &:empty?
    end

    def filled?
      empty_cells.empty?
    end

    def unused_values
       complete_values - non_empty_cell_values
    end

    def complete_values
      (1..9).to_a
    end
  end
end