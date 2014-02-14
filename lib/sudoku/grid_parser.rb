module Sudoku
  class GridParser
    def parse_line(line)
      line.chars.map do |char|
        Sudoku::Cell.parse(char)
      end
    end

    def parse_string(string)
      rows = string.each_line.map do |line|
        parse_line(line.strip)
      end
      Sudoku::Grid.new rows
    end
  end
end