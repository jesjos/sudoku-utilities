module Sudoku
  class Grid
    attr_reader :rows
    def initialize(rows = nil)
      @rows = rows
      @rows ||= Array.new(9) {Array.new(9) { Cell.new } }
    end

    def columns
      @columns ||= rows.transpose
    end

    def quadrants
      @quadrants ||= [0,3,6].repeated_permutation(2).inject([]) do |memo, (row, column)|
        affected_rows = rows[row..row + 2]
        memo << affected_rows.inject([]) {|quadrant, row| quadrant + row[column..column+2]}
      end
    end

    def cells
      @cells ||= rows.inject([]) {|sum, row| sum += row}
    end

    def empty_cells
      cells.reject {|cell| !cell.empty?}      
    end

    def to_s
      rows.map do |row|
        row.map(&:to_s).join
      end.join("\n")
    end

    def clone
      other_rows = rows.map {|row| clone_row(row)}
      Grid.new(other_rows)
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


    class << self

      def parse(string)
        Sudoku::GridParser.new.parse_string(string)
      end

    end

  end
end