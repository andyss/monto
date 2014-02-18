require "monto/inflections"
require "monto/inflector/methods"

module Monto
  module Tableable
    extend Concernable
        
    def table_name
      self.class.table_name
    end
    
    module ClassMethods
      def table_name
        Inflector.pluralize(Inflector.underscore(self.to_s))
      end
    end
  end
end