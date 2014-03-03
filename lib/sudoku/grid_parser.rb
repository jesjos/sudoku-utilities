module Sudoku
  class GridParser
    def parse_line(line)
      line.chars.map(&:to_i)
    end

    def parse_string(string)
      values = string.each_line.reduce([]) do |values, line|
        values += parse_line(line.strip)
      end
      values
    end

    def parse(string, klass = Sudoku::PropagatingGrid)
      klass.new parse_string(string)
    end
  end
end