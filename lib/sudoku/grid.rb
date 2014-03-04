module Sudoku
  # = Grid
  # Abstract class which contains shared logic for all kinds of grids.
  # Known subclasses:
  # - PropagatingGrid
  # - NonPropagatingGrid
  class Grid
    extend Forwardable
    include PeersAndUnits
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

    def values_to_s
      sorted_keys.map {|key| "#{key} => #{values[key].inspect}"}.join(", ")
    end

    def default_possible_values
      Hamster.set *(1..9).to_a
    end

    def extract_row(key)
      key[0]
    end

    def extract_column(key)
      key[1]
    end

    def set_initial_values(input = nil)
      if input.respond_to? :values
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

    def set_empty_grid
      @values = sorted_keys.reduce(@values) do |values, key|
        values.put(key, default_possible_values)
      end
    end

    def set_values(input)
      sorted_keys.zip(input).each do |(key, value)|
        result = set(key, value)
      end
    end

    def set(key, value)
      raise "Subclasses must override"
    end

    def eql?(other)
      self.values.eql?(other.values)
    end

    def empty_values
      values.select {|key, value| value.size > 1 }
    end

    def sorted_empty_values
      hash = empty_values.reduce({}) {|mem, key, values| mem[key] = values; mem}
      hash.sort{|(one_key, one_values), (other_key, other_values)| one_values.size <=> other_values.size}
    end

    class << self

      def parse(*args)
        Sudoku::GridParser.new.parse(*args)
      end

    end

    private

    def debug(string)
      if @debug
        debug string
      end
    end

  end
end