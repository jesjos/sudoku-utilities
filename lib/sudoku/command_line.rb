module Sudoku
  class SudokuSolver < Thor
    desc "read", "Reads a sudoku and prints it"
    method_option :file, aliases: "-f", desc: "Read input from a file", required: false
    def read(*args)
      if path = options[:file]
        raise "Could not read file" unless File.exists?(path)
        file = File.open(path)
        grid = Grid.parse(file.read)
        solver = Solver.new(grid)
        solver.solve
        puts grid
      end
    end
  end
end
