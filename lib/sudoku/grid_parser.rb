module Sudoku
  class GridParser
    def parse_line(line)
      squares = line.chars.map(&:to_i)
      raise "Illegal line length" if squares.size != 9
      squares
    end

    def parse_string(string)
      values = string.each_line.reduce([]) do |values, line|
        values += parse_line(sanitize_line(line))
      end
      raise "Sudoku doesn't have 81 squares" if values.size != 81
      values
    end

    def sanitize_line(line)
      line.strip.gsub("\r", "")
    end

    def parse(string, klass = Sudoku::PropagatingGrid)
      klass.new parse_string(string.strip)
    end
  end
end