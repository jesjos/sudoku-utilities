module Sudoku
  class NullObject
    def method_missing(meth, *args, &blk)
      self  
    end

    def nil?
      true
    end

    def as_json; nil; end

    def tap; self; end
  end
end