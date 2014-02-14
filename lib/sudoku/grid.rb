module Sudoku
  class Grid
    attr_reader :rows
    def initialize
      @rows = Array.new(9, Array.new(9, Cell.new))
    end

    def columns
      rows.transpose
    end

    def cells
      rows.inject([]) {|sum, row| sum += row}
    end

    def to_s
      rows.map do |row|2
        row.map(&:to_s).join
      end.join("\n")
    end

    class << self

      def parse(string)
        
      end

    end

  end
end