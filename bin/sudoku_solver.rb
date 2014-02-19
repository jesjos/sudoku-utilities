#!/usr/bin/env ruby
require "rubygems" # ruby1.9 doesn't "require" it though
require File.expand_path('../lib/sudoku', File.dirname(__FILE__)) 

Sudoku::SudokuSolver.start