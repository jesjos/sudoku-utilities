module Sudoku
  class Grid
    attr_reader :rows
    def initialize
      @rows = Array.new(9, Array.new(9, Cell.new))
    end

    def columns
      rows.transpose
    end

    class << self

      def parse(string)
        
      end

    end

  end
end