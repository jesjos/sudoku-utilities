require 'curses'
module Sudoku
  class SudokuSolver < Thor
    desc "read", "Reads a sudoku and prints it"
    method_option :file, aliases: "-f", desc: "Read from a file and print", required: false
    def read(*args)
      string = read_file(*args)
      grid = Grid.parse(string)
      puts grid.to_s
    end

    desc "solve", "Reads a sudoku and solves it"
    method_option :file, aliases: "-f", desc: "Read from a file and solve", required: false
    def solve(*args)
      if path = options[:file]
        begin
          file = File.open(path)
          grid = Grid.parse(file.read)
          solver = Solver.new(grid)
          result = solver.solve(&print_method)
          window.clear
          window << "Solving took: #{solver.total_time} seconds\n"
          if result
            window << "Solved sudoku:\n"
            window << solver.solved_grids.first.to_s
          else
            window << "Could not find an answer"
          end
        rescue Exception => e
          window.clear
          window << "Something went wrong, #{e.message}"
        end
      end
      window.getch
      window.close
    end

    private

    def parse_multiple(file)
      content = file.read
      content.split("=\n").map {|grid| Grid.parse(grid)}
    end

    def read_file(*args)
      path = options[:file]
      file = File.open(path)
      file.read
    end

    def window
      @window ||= init_window
    end

    def init_window
      win = Curses::Window.new(100,100,0,0)
      win.refresh
      win
    end

    def print_method
      ->(grid) { window.clear; window << grid.to_s; window.refresh }
    end
  end
end
