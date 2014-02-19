module Sudoku
  class Grid
    attr_reader :rows
    def initialize(arg = nil)
      if arg
        if arg.respond_to? :each
          @rows = arg
        else
          fill_rows_with_value(arg)
        end
      else
        set_empty_rows
      end
    end

    def columns
      @columns ||= rows.to_a.transpose
    end

    def quadrants
      @quadrants ||= [0,3,6].repeated_permutation(2).inject([]) do |memo, (row, column)|
        affected_rows = rows.to_a[row..row + 2]
        memo << affected_rows.inject([]) {|quadrant, row| quadrant + row.to_a[column..column+2]}
      end
    end

    def cell_rows
      rows.to_a.map do |row|
        row.to_a.map {|value| Cell.new value}
      end
    end

    def cells
      @cells ||= cell_rows.inject([]) {|sum, row| sum += row }
    end

    def empty_cells
      cells.reject {|cell| !cell.empty?}      
    end

    def to_s
      cell_rows.map do |row|
        row.map(&:to_s).join
      end.join("\n")
    end

    def clone_row(row)
      row.map {|cell| cell.clone}
    end

    def regions
      @regions ||= column_regions + row_regions + quadrant_regions
    end

    def column_regions
      @column_regions ||= columns.map {|column| Sudoku::Region.new(column)}
    end

    def row_regions
      @row_regions ||= rows.map {|row| Sudoku::Region.new(row)}
    end

    def quadrant_regions
      @quadrant_regions ||= quadrants.map {|quadrant| Sudoku::Region.new(quadrant)}
    end

    def set(args)
      row_index, col_index, value = args[:row], args[:column], args[:value]
      new_row   = rows[row_index].set(col_index, value)
      new_rows  = rows.set(row_index, new_row)
      Grid.new new_rows
    end

    def get(row, column)
      rows[row][column]
    end

    def fill_rows_with_value(value)
      rows = 1.upto(9).map {|n| Hamster.vector(*Array.new(9,value))}
      @rows = Hamster.vector(*rows)
    end

    def set_empty_rows
      fill_rows_with_value(0)
    end

    class << self

      def parse(string)
        Sudoku::GridParser.new.parse_string(string)
      end

    end

  end
end