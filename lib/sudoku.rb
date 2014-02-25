require 'thor'
require 'forwardable'
require 'hamster'
['sudoku/grid',
'sudoku/grid_parser',
'sudoku/solver',
'sudoku/command_line'].each do |file|
  require File.expand_path(file, File.dirname(__FILE__)) 
end
