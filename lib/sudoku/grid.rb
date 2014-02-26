module Sudoku

  # = Grid
  # Represents a sudoku grid.
  class Grid
    extend Forwardable

    def_delegator :values, :hash, :hash

    ROW_KEYS = ("A".."I").to_a
    COLUMN_KEYS = (1..9).to_a
    SORTED_KEYS = 
      ROW_KEYS.reduce([]) do |keys, row| 
        COLUMN_KEYS.reduce(keys) do |keys, column| 
          keys << "#{row}#{column}"
        end
      end

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
      SORTED_KEYS
    end

    # Since constraint propagation can cause some 
    # squares to be assigned values when a grid is loaded
    # we keep the original around to be able to produce a 
    # string representation that makes sense
    def to_s
      unless @original
        source = cells_as_strings
      else
        source = original_input_as_strings
      end
      source.each_slice(9).to_a.map(&:join).join("\n")# + "\n" + values_to_s
    end

    def values_to_s
      sorted_keys.map {|key| "#{key} => #{values[key].inspect}"}.join(", ")
    end

    def cells_as_strings
      sorted_keys.map {|key| to_s_cell(values[key])}
    end

    def original_input_as_strings
      @original.map do |value|
        if value == 0
          "."
        else
          value.to_s
        end
      end
    end

    def to_s_cell(cell)
      if cell.size == 1
        cell.first.to_s
      else
        "."
      end
    end

    def default_possible_values
      Hamster.set *(1..9).to_a
    end

    def peer_keys(key)
      Set.new(row_peer_keys(key) + column_peer_keys(key) + box_peer_keys(key))
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

    def eliminate_from_peers_of(key, value)
      peer_keys(key).reduce(true) do |result, key|
        current_values = values[key]
        unless current_values.include? value
          result &= true
        else
          new_values = current_values.delete(value)
          if new_values.empty?
            result &= false
          else
            @values = values.put(key, new_values)
            if new_values.size == 1
              result &= eliminate_from_peers_of(key, new_values.first)
            else
              result &= true
            end
          end
        end
      end
    end

    def set_values(input)
      sorted_keys.zip(input).each do |(key, value)|
        result = set key, value
      end
    end

    def set(key, value)
      if value == 0
        # Do nothing
        true
      else
        assign_and_eliminate(key, value)
      end
    end

    def empty_values
      values.select {|key, value| value.size > 1 }
    end

    def sorted_empty_values
      hash = empty_values.reduce({}) {|mem, key, values| mem[key] = values; mem}
      hash.sort{|(one_key, one_values), (other_key, other_values)| one_values.size <=> other_values.size}
    end

    def clone
      Grid.new(self)
    end

    def eql?(other)
      self.values.eql?(other.values)
    end

    class << self

      def parse(string)
        Sudoku::GridParser.new.parse(string)
      end

    end
    
    private

    def set_initial_values(input = nil)
      if input.is_a? Grid
        set_grid(input)
      else
        set_empty_grid
        if input.respond_to? :each
          set_from_array(input)
        end
      end
    end

    def set_grid(other_grid)
      @values = other_grid.values
    end

    def set_from_array(array)
      raise "Not enough cells" unless array.size == 81
      @original = array
      set_values(array)
    end

    def assign_and_eliminate(key, value)
      if values[key].include? value
        @values = values.put(key, Hamster.set(value))
        eliminate_from_peers_of(key, value)
      else
        false
      end
    end

    def set_empty_grid
      @values = sorted_keys.reduce(@values) do |values, key|
        values.put(key, default_possible_values)
      end
    end

  end
end