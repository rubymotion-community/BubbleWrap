module NSIndexPathWrap

  # Gives access to an index at a given position.
  # @param [Integer] position to use to fetch the index
  # @return [Integer] the index for the given position
  def [](position)
    raise ArgumentError unless position.is_a?(Integer)
    indexAtPosition(position)
  end

  # Provides an iterator taking a block following the common Ruby idiom.
  # @param [Block]
  # @return [NSIndexPath] the iterated object itself
  def each
    i = 0
    until i == self.length
      yield self.indexAtPosition(i)
      i += 1
    end
    self
  end

end
