module Monto
  module Saveable
        
    def _save
      self._id = insert
      @new_record = false
      p "save to table #{self.table_name}"
    end
    
    def insert(options = {})
      collection.insert(as_document)
    end
  end
end