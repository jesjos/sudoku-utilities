module Sudoku
  class GridParser
    def initialize(string)
      @string = string
    end

    def parse_line(line)
      line.chars.map do |char|
        Sudoku::Cell.parse(char)
      end
    end
  end
end