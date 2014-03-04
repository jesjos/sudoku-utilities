module Sudoku
  class NonPropagatingGrid < Grid
    include PeersAndUnits

    def set(key, value)
      if value == 0
        true
      else
        @values = values.put(key, Hamster.set(value))
      end
    end

    def values_array
      sorted_keys.map {|key| value_for_key(key)}
    end

    def value_for_key(key)
      possible_values = values[key]
      if possible_values.size == 1
        possible_values.first
      else
        0
      end
    end

    def to_propagating_grid
      PropagatingGrid.new values_array
    end
    
  end
end