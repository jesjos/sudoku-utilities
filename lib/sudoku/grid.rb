module Sudoku

  # = Grid
  # Represents a sudoku grid.
  #
  # == Vocabulary
  # - Grid:   the sudoku's 9x9 grid
  # - Square: one of the 81 squares, is empty or holds a value between 1 and 9
  # - Unit: all of the squares in a row, a column or a 3x3 box. 
  class Grid
    extend Forwardable
    include Units

    def_delegator :values, :hash, :hash

    # +values+ holds the possible values for each square in the grid
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

    def to_s
      cells_as_strings.each_slice(9).to_a.map(&:join).join("\n")# + "\n" + values_to_s
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

    def values_to_s
      sorted_keys.map {|key| "#{key} => #{values[key].inspect}"}.join(", ")
    end

    def default_possible_values
      Hamster.set *(1..9).to_a
    end

    def peer_keys(key)
      PEERS[key]
    end

    def extract_row(key)
      key[0]
    end

    def extract_column(key)
      key[1]
    end

    def eliminate_from_peers_of(key, value)
      peer_keys(key).all? do |key|
        eliminate(key, value)
      end
    end

    def units_containing(key)
      UNITS.select do |unit|
        unit.include? key
      end
    end

    def eliminate(key, value)
      current_values = values[key]
      unless current_values.include? value
        return true
      end
      new_values = current_values.delete(value)
      if new_values.empty?
        return false
      end
      @values = @values.put(key, new_values)
      if new_values.size == 1
        return false unless eliminate_from_peers_of(key, new_values.first)
      end
      return false unless eliminate_single_occurrence(key, value)
      return true
    end

    def eliminate_single_occurrence(key, value)
      units_containing(key).all? do |unit|
        eliminate_single_occurrence_in_unit(unit, value)
      end
    end

    def eliminate_single_occurrence_in_unit(unit, value)
      keys = unit.select {|key| values[key].include? value }
      return set(keys.first, value) if keys.size == 1
      true
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

    def total_possible_values
      values.reduce(0) {|sum, key, value| toal}
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
      set_values(array)
    end

    def assign_and_eliminate(key, value)
      current_values = values[key]
      if current_values.include? value
        remaining_values = current_values.delete(value)
        remaining_values.all? do |value_to_be_eliminated|
          eliminate(key, value_to_be_eliminated)
        end
      else
        false
      end
    end

    def set_empty_grid
      @values = sorted_keys.reduce(@values) do |values, key|
        values.put(key, default_possible_values)
      end
    end

    def debug(string)
      if @debug
        debug string
      end
    end

  end
end