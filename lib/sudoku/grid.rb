module Sudoku
  class Grid
    attr_reader :rows
    def initialize(rows = nil)
      @rows = rows
      @rows ||= Array.new(9, Array.new(9, Cell.new))
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

    def to_s
      rows.map do |row|2
        row.map(&:to_s).join
      end.join("\n")
    end

    class << self

      def parse(string)
        Sudoku::GridParser.new.parse_string(string)
      end

    end

  end
end