module Sudoku
  # # Cell
  # A cell in a Sudoku puzzle
  # For simplicity, all values except 1..9 are considered to 
  # represent an empty cell, which is in turn represented by the
  # value 0.
  class Cell
    attr_accessor :value, :possible_values, :row, :column, :grid
    def initialize(value = 0, options = {})
      sanity_check!(value)
      @value = value
      @row = options[:row]
      @column = options[:column]
      @grid = options[:grid]
      init_possible_values
    end

    def set(value)
      grid.set(row: row, column: column, value: value)
    end

    def sanity_check!(value)
      raise "Invalid cell value" unless sane?(value)
    end

    def sane?(value)
      return false unless value.respond_to?(:to_i)
      value.to_i.between?(0,9)
    end

    def empty?
      @value == 0
    end

    def value=(i)
      sanity_check!(i)
      possible_values = []
      @value = i
    end

    def eql?(other)
      return false unless other.respond_to? :value
      other.value == value
    end

    def to_s
      if value == 0
        "."
      else
        value.to_s
      end
    end

    def no_possible_values?
      possible_values.empty?
    end

    def number_of_possible_values
      possible_values.size
    end

    class << self
      def parse(character)
        Sudoku::Cell.new(character.to_i)
      end
    end

    private

    def init_possible_values
      if empty?
        @possible_values = (1..9).to_a
      else
        @possible_values = []
      end
    end

  end
end