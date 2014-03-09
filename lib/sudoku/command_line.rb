require 'curses'
module Sudoku
  class SudokuSolver < Thor
    desc "read", "Reads a sudoku and prints it"
    method_option :file, aliases: "-f", desc: "Read from a file and print", required: true
    def read(*args)
      string = read_file(*args)
      grid = Grid.parse(string, NonPropagatingGrid)
      puts grid.to_s
    end

    desc "solve", "Reads a sudoku and solves it"
    method_option :file, aliases: "-f", desc: "Read from a file and solve", required: true
    def solve(*args)
      if path = options[:file]
        begin
          grid = Grid.parse(read_file)
          solver = Solver.new(grid)
          result = solver.solve(&print_method)
          window.clear
          window << "Solving took: #{solver.total_time} seconds\n"
          if result
            window << "Solved sudoku:\n"
            window << solver.solution.to_s
            window << "\nFound #{solver.solved_grids.size} solution"
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

    desc "generate", "Generates a Sudoku"
    method_option :difficulty, aliases: "-d", desc: "Choose a difficulty from [easy, medium, hard, samuraj]", required: false
    def generate
      difficulty = options[:difficulty] || "easy"
      generator = Generator.new
      puts "Generating Sudoku ..."
      sudoku = generator.generate(difficulty)
      puts "Generated #{difficulty} sudoku", sudoku
    end


    desc "analyze", "Analyzes Sudoku difficulty"
    method_option :file, aliases: "-f", desc: "Read from a file and print", required: true
    def analyze
      string = read_file
      sudoku = Grid.parse(string, NonPropagatingGrid)
      analyzer = DifficultyAnalyzer.new(sudoku)
      puts "Sudoku difficulty is #{analyzer.difficulty}"
    end

    private

    def read_file(*)
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
