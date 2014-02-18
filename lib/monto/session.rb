require "monto/session/factory"
require "monto/session/storage_option"
require "monto/session/thread_option"
require "monto/session/option"

module Monto
  module Session
    extend Concernable
    
    include StorageOption
    include ThreadOption
    include Option
    
    attr_reader :current_database
    
    class << self
      def clear
        Threaded.sessions.clear
      end

      def default
        Threaded.sessions[:default] ||= Session::Factory.default
      end

      def disconnect
        Threaded.sessions.values.each do |session|
          session.disconnect
        end
      end

      def with_name(name)        
        Threaded.sessions[name.to_sym] ||= Session::Factory.create(name)
      end
    end 
    
    def collection
      self.class.collection
    end

    def mongo_session
      super || self.class.mongo_session
    end

    def table_name
      super || self.class.table_name
    end
    
    def db
      self.class.db
    end

    module ClassMethods

      def mongo_session
        session = Session.with_name("default")
        session
      end
      
      def db
        @current_database ||= mongo_session.db(database_name.to_s)
      end

      def collection
        @current_collection ||= db.collection(collection_name)
      end
    end
    
  end
end