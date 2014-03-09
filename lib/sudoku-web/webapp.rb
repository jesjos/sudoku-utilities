require 'sinatra'
require 'addressable/uri'
require File.expand_path("../sudoku", File.dirname(__FILE__))

before do
  @error = params[:error]
  puts params.inspect
end

['/', '/solver'].each do |path|
  get path do
    @example_sudoku = format_sudoku <<-eos
      ..3.2.6..
      9..3.5..1
      ..18.64..
      ..81.29..
      7.......8
      ..67.82..
      ..26.95..
      8..2.3..9
      ..5.1.3..
    eos
    haml :solver
  end
end

get '/generator' do
  @difficulties = ["easy", "medium", "hard", "samuraj"]
  haml :generator
end

post '/generate' do
  difficulty = params[:difficulty]
  generator = Sudoku::Generator.new
  begin 
    sudoku = generator.generate(difficulty)
    redirect to(construct_generated_url(sudoku: sudoku.to_s, difficulty: difficulty))
  rescue Exception => e
    error = "Could not generate sudoku <br>" + e.message
    redirect to(construct_generated_url(error: error))
  end
end

get '/generated' do
  @sudoku = format_sudoku(params[:sudoku])
  @difficulty = params[:difficulty]
  haml :generated
end

get '/analyzer' do
  haml :analyzer
end

post '/analyze' do
  @sudoku = params[:sudoku]
  begin
    @grid = Sudoku::Grid.parse(@sudoku, Sudoku::NonPropagatingGrid)
    @difficulty_analyzer = Sudoku::DifficultyAnalyzer.new(@grid)
    redirect to(construct_analyzed_url(difficulty: @difficulty_analyzer.difficulty, sudoku: @grid.to_s))
  rescue Exception => e
    error = "Could not parse your grid\n" + e.message
    redirect to(construct_analyzed_url(error: error))
  end
end

get '/analyzed' do
  @sudoku = format_sudoku(params[:sudoku])
  @difficulty = params[:difficulty]
  haml :analyzed
end


post '/solve' do
  @sudoku = params[:sudoku]
  begin
    @grid = Sudoku::Grid.parse @sudoku
    @solver = Sudoku::Solver.new(@grid)
    result = @solver.solve
    redirect to(construct_solved_url(solved: result, solution: @solver.solution.to_s, unique: @solver.unique_solution?))
  rescue Exception => e
    error = "Could not parse your Sudoku <br>" + e.message
    redirect to(construct_solved_url(error: error))
  end
end

get '/solved' do
  @sudoku = format_sudoku(params[:solution])
  @unique = params[:unique]
  haml :solved
end

def construct_generated_url(options = {})
  construct_url("/generated", options)
end

def construct_solved_url(options = {})
  construct_url("/solved", options)
end

def construct_analyzed_url(options = {})
  construct_url("/analyzed", options)
end

def construct_url(path, options)
  uri = Addressable::URI.new
  uri.path = path
  uri.query_values = options
  uri.to_s
end

def format_sudoku(string)
  string.gsub("\n", "<br>") unless string.nil?
end