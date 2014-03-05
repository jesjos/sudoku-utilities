require 'rubygems'
require 'bundler/setup'
require 'thor'
require 'forwardable'
require 'hamster'
require 'distribution'
['sudoku/peers_and_units',
'sudoku/grid',
'sudoku/propagating_grid',
'sudoku/non_propagating_grid',
'sudoku/difficulty_analyzer',
'sudoku/grid_parser',
'sudoku/solver',
'sudoku/generator',
'sudoku/command_line'].each do |file|
  require File.expand_path(file, File.dirname(__FILE__)) 
end
