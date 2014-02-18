require "monto/threaded"
require "monto/ext/module"
require "monto/migrate"
require "monto/saveable"
require "monto/tableable"
require "monto/attribute"
require "monto/findable"
require "monto/stateable"
require "monto/migrate/column"

module Monto
  module Base        
    extend Concernable
    
    include Threaded::Lifecycle
    include Monto::Session
    
    include Saveable
    include Attribute
    include Tableable
    include Stateable
    include Findable
    
    include Migrate::Column
    
    def self.included(base)
      if defined?(ActiveRecord::Base) && base < ActiveRecord::Base
        base.send(:after_save, :_save)
        base.send(:after_initialize, :init)
      else
        base.send(:include, NotActiveRecord)
      end
    end    
    
    def init(attrs={})
      _building do
        @new_record = true
        @attributes ||= attrs
      end
    end
    
    def as_document
      attributes
    end
            
    module NotActiveRecord
      def initialize(attrs={})
        init(attrs)
      end
      
      def save
        _save
      end
    end
  end
end