module Sudoku

  # = PropagatingGrid
  # Represents a sudoku grid. 
  # A propagating grid uses constraint propagation to 
  # keep track of the effects of setting the value of a square
  # on the possible values of other squares.
  #
  # == Vocabulary
  # - Grid:   the sudoku's 9x9 grid
  # - Square: one of the 81 squares, is empty or holds a value between 1 and 9
  # - Unit:   all of the squares in a row, a column or a 3x3 box. 
  # - Peer:   for a given square, the peers are the squares that are in the same unit(s)
  #
  # == Data structure
  #
  # The grid stores the possible values for each square in the grid.
  # A square has been set if it has only one possible value.
  #
  # == Notes
  # The grid takes care of constraint propagation.
  # This means that as soon as you set the value of a square,
  # we eliminate that value from the possible values of the peers
  # of that square
  class PropagatingGrid < Grid

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

    # Checks if there's only one possible position left
    # for a value in all units which contain the given key
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

    def clone
      PropagatingGrid.new(self)
    end

    def total_possible_values
      values.reduce(0) {|sum, key, value| toal}
    end

    def eliminate_from_peers_of(key, value)
      peer_keys(key).all? do |key|
        eliminate(key, value)
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

    private

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

  end
end