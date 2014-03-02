module Sudoku
  module PeersAndUnits
    ROW_KEYS    = ("A".."I").to_a
    COLUMN_KEYS = (1..9).to_a
    SORTED_KEYS = ROW_KEYS.product(COLUMN_KEYS).map {|(row, column)| row + column.to_s}

    ROW_UNITS     = SORTED_KEYS.each_slice(9).to_a
    COLUMN_UNITS  = ROW_UNITS.transpose

    # Generate keys for all of the 3x3 boxes
    ROW_RANGES    = ROW_KEYS.each_slice(3).to_a
    COLUMN_RANGES = COLUMN_KEYS.each_slice(3).to_a
    BOX_UNITS     = ROW_RANGES.reduce([]) do |units, row_range| 
      units += COLUMN_RANGES.map do |col_range| 
        row_range.product(col_range).map {|(row, column)| row + column.to_s}
      end
    end

    UNITS = ROW_UNITS + COLUMN_UNITS + BOX_UNITS

    PEERS = Hash.new {|hash, key| hash[key] = Set.new}
    SORTED_KEYS.reduce(PEERS) do |peers, key|
      UNITS.each do |unit|
        if unit.include? key
          peers[key] += unit.reject {|other_key| key == other_key }
        end
      end
      peers
    end

    def units_containing(key)
      UNITS.select do |unit|
        unit.include? key
      end
    end
  end
end