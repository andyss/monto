class String
  def classify
    self.split('_').collect(&:capitalize).join
  end
  
  def underscore
    word = self.dup
    word.gsub!('::', '/')

    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word        
  end
  
  def pluralize
    
  end
  
  def singularize
  end
end
