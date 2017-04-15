class UIView
  
  def self.build(args = {})
    element = self.alloc.init
    args.each do |a, i|
      element.send("#{a}=".to_sym, i)
    end
    element
  end

end