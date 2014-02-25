module Sudoku
  class Grid

    ROW_KEYS = ("A".."I").to_a
    COLUMN_KEYS = (1..9).to_a

    attr_accessor :values
    
    def initialize(input = nil)
      @values = Hamster.hash
      set_initial_values(input)
    end

    def column_keys
      COLUMN_KEYS
    end

    def row_keys
      ROW_KEYS
    end

    # Since Hamster::Set doesn't guarantee sorted keys,
    # we'll use this method to ensure a sorted key set.
    def sorted_keys
      @sorted_keys ||= ROW_KEYS.reduce([]) do |keys, row| 
        COLUMN_KEYS.reduce(keys) do |keys, column| 
          keys << construct_key(row, column)
        end
      end
    end

    def to_s
      cells_as_strings.each_slice(9).to_a.map(&:join).join("\n")
    end

    def cells_as_strings
      sorted_keys.map {|key| to_s_cell(values[key])}
    end

    def to_s_cell(cell)
      if cell.size == 1
        cell.first.to_s
      else
        "."
      end
    end

    class << self

      def parse(string)
        Sudoku::GridParser.new.parse(string)
      end

    end

    def default_possible_values
      Hamster.set *(1..9).to_a
    end

    def peer_keys(key)
      row_peer_keys(key) + column_peer_keys(key) + box_peer_keys(key)
    end

    def row_peer_keys(key)
      row = extract_row key
      keys = column_keys.map {|column| construct_key(row, column)}
      keys.reject{|output_key| output_key == key }
    end

    def column_peer_keys(key)
      column = extract_column key
      keys = row_keys.map {|row| construct_key(row, column)}
      keys.reject{|output_key| output_key == key }
    end

    def box_peer_keys(key)
      row_keys = box_row_keys(key)
      column_keys = box_column_keys(key)
      keys = row_keys.reduce([]) do |keys, row|
        keys += column_keys.map {|col| construct_key(row, col)}
      end
      keys.reject{|output_key| output_key == key}
    end

    def box_row_keys(key)
      row = extract_row key
      case row
      when "A".."C"
        ["A", "B", "C"]
      when "D".."F"
        ["D", "E", "F"]
      when "G".."I"
        ["G", "H", "I"]
      end
    end

    def box_column_keys(key)
      column = extract_column key
      case column.to_i
      when (1..3)
        [1,2,3]
      when (4..6)
        [4,5,6]
      when (7..9)
        [7,8,9]
      end
    end

    def deconstruct_key(key)
      [key[0], key[1]]
    end

    def construct_key(row, column)
      "#{row}#{column}"
    end

    def extract_row(key)
      key[0]
    end

    def extract_column(key)
      key[1]
    end

    def eliminate(key, value)
      peer_keys(key).each do |key|
        current_values = values[key]
        @values = values.put(key, current_values.delete(value))
      end
    end

    def set_values(input)
      sorted_keys.zip(input).each do |(key, value)|
        set key, value
      end
    end

    def set(key, value)
      if value == 0
        @values = values.put(key, default_possible_values)
      else
        assign_and_eliminate(key, value)
      end
    end

    def clone
      Grid.new(self)
    end

    private

    def set_initial_values(input = nil)
      if input.is_a? Grid
        @values = input.values
      else
        set_empty_grid
        if input.respond_to? :each
          raise "Not enough cells" unless input.size == 81
          set_values(input)
        end
      end
    end

    def assign_and_eliminate(key, value)
      @values = values.put(key, Hamster.set(value))
      eliminate(key, value)
    end

    def set_empty_grid
      @values = sorted_keys.reduce(@values) do |values, key|
        values.put(key, default_possible_values)
      end
    end

  end
end