# Sudoku Utilities

This is a set of Sudoku utilities written in Ruby.

Included utilities:

1. Sudoku solving
2. Checking for uniqueness of solution
3. Analysis of Sudoku difficulty
4. Generating Sudokus of different difficulties

# Usage

## Ruby code

Just read the specs :)

## Web interface

There are three methods of booting the web interface:

1. `ruby ./lib/sudoku-web/webapp.rb`
2. `rackup config.ru`
3. `foreman start` <- preferred for development

## Command line utility

### Getting started

You need to make `bin/sudoku_utilities.rb` executable to be able to run the commands.

### Listing commands

    > ./bin/sudoku_utilities.rb

### Reading

The utility expects a file containing nine rows of nine columns each. 
Digits other than 1..9 will be considered to represent empty squares.

    > ./bin/sudoku_utilities.rb read -f ./spec/test_grids/samuraj.txt
      5.....1.7
      ..43..5..
      ...2...8.
      .9.4.2...
      4.......6
      ...1.3.5.
      .8...4...
      ..2..67..
      3.9.....1

### Solving

    > ./bin/sudoku_utilities.rb solve -f ./spec/test_grids/samuraj.txt
      Solving took: 0.076007 seconds
      Solved sudoku:
      538649127
      274381569
      916275483
      691452378
      453798216
      827163954
      785914632
      142836795
      369527841
      Found 1 solution

### Analyzing

    > ./bin/sudoku_utilities.rb analyze -f ./spec/test_grids/samuraj.txt
      Sudoku difficulty is samuraj

### Generating

The available difficulties are:

- easy
- medium
- hard
- samuraj

At the time of writing, difficulties are naïve and only based upon the number of given squares.

N.B - Sudoku generation can take several tens of seconds.

    > ./bin/sudoku_utilities.rb generate -d samuraj
      Generating Sudoku ...
      Generated samuraj sudoku
      ....8...2
      .3.29..7.
      ...47..68
      ....1..53
      9..8.2...
      .5..3....
      ..6.....7
      ..2.6....
      .8.1.....

# Licensing

Copyright (c) 2014 Jesper Josefsson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.