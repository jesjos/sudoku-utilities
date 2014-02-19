module Sudoku
  class GridParser
    def parse_line_with_number(line, row_index)
      row = Hamster.vector
      line.chars.each_with_index do |char, column|
        cell = char.to_i
        row = row.add cell 
      end
      row
    end

    def parse_string(string)
      rows = Hamster.vector
      string.each_line.each_with_index do |line, i|
        rows = rows.add parse_line_with_number(line.strip, i)
      end
      Sudoku::Grid.new rows
    end
  end
end