module NSIndexPathWrap

  def +(aNumber)
    self.class.indexPathForRow(row+aNumber, inSection:section)
  end

  def -(aNumber)
    self.class.indexPathForRow(row-aNumber, inSection:section)
  end

end
