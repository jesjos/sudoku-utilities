require 'curses'
module Sudoku
  class SudokuSolver < Thor
    desc "read", "Reads a sudoku and prints it"
    method_option :file, aliases: "-f", desc: "Read from a file and solve", required: false
    def read(*args)
      if path = options[:file]
        begin
          file = File.open(path)
          grid = Grid.parse(file.read)
          solver = Solver.new(grid, &print_method)
          solver.solve
          window.clear
          window << "Solving took: #{solver.total_time} seconds\n"
          window << "Found #{solver.solved_grids.size} solutions"
          window << "Sudoku:\n"
          window << solver.solved_grids.first.to_s
        rescue Exception => e
          window.clear
          window << "Something went wrong, #{e.message}"
        end
      end
      window.getch
      window.close
    end

    desc "multiple", "Reads multiple sudokus and solves them"
    method_option :file, aliases: "-f", desc: "Read from a file and solve multiple sudokus", required: true
    def multiple(*args)
      file = File.open(options[:file])
      grids = parse_multiple(file)
      count = grids.map {|grid| solve(grid)}.count
      window << "Solved #{count} grids"
      window.getch
      window.close
    end

    private

    def parse_multiple(file)
      content = file.read
      content.split("=\n").map {|grid| Grid.parse(grid)}
    end

    def solve(grid)
      solver = Solver.new(grid, &print_method)
      result = solver.solve
      window.clear
      window << "Solving took: #{solver.total_time} seconds\n"
      window << "Sudoku:\n"
      window << result.to_s
      result
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
      -> (grid) { window.clear; window << grid.to_s; window.refresh }
    end
  end
end
