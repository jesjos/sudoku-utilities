require 'thor'
require 'forwardable'
require 'hamster'
['sudoku/region',
'sudoku/grid',
'sudoku/grid_parser',
'sudoku/cell',
'sudoku/solver',
'sudoku/command_line'].each do |file|
  require File.expand_path(file, File.dirname(__FILE__)) 
end
