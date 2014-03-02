require 'rubygems'
require 'bundler/setup'
require 'thor'
require 'forwardable'
require 'hamster'
['sudoku/peers_and_units',
'sudoku/grid',
'sudoku/propagating_grid',
'sudoku/non_propagating_grid',
'sudoku/grid_parser',
'sudoku/solver',
'sudoku/command_line'].each do |file|
  require File.expand_path(file, File.dirname(__FILE__)) 
end
