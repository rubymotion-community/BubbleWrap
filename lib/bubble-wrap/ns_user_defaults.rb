# Reopens the NSUserDefaults class to add Array like accessors
# @see https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Classes/nsuserdefaults_Class/Reference/Reference.html
class NSUserDefaults

  # Retrieves the object for the passed key
  def [](key)
    self.objectForKey(key.to_s)
  end

  # Sets the value for a given key and save it right away.
  def []=(key, val)
    self.setObject(val, forKey: key.to_s)
    self.synchronize
  end
end
