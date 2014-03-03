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
    
  end
end