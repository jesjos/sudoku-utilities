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

    def parse_string(string)
      string.each_line.map do |line|
        parse_line(line)
      end      
    end
  end
end