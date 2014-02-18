module Monto
  module Session
    module Option
      extend Concernable
      
      def with(options)
        @persistence_options = options
        self
      end

      def persistence_options
        @persistence_options
      end

      def mongo_session
        if persistence_options
          session_name = persistence_options[:session] || self.class.session_name
          Session.with_name(session_name).with(persistence_options)
        end
      end

      def collection_name
        if persistence_options && v = persistence_options[:collection]
          return v.to_sym
        end
      end
      
      module Threaded

        def persistence_options(klass = self)
          Thread.current["[monto][#{klass}]:persistence-options"]
        end

        private
        def set_persistence_options(klass, options)
          Thread.current["[monto][#{klass}]:persistence-options"] = options
        end
      end

      module ClassMethods
        include Threaded

        def session_name
          if persistence_options && v = persistence_options[:session]
            return v.to_sym
          end
          super
        end

        def collection_name
          if persistence_options && v = persistence_options[:collection]
            return v.to_sym
          end
          super
        end

        def database_name
          if persistence_options && v = persistence_options[:database]
            return v.to_sym
          end
          super
        end

        def with(options)
          Proxy.new(self, (persistence_options || {}).merge(options))
        end
      end

      class Proxy < BasicObject
        include Threaded

        undef_method :==

        def initialize(target, options)
          @target = target
          @options = options
        end

        def persistence_options
          @options
        end

        def respond_to?(*args)
          @target.respond_to?(*args)
        end

        def method_missing(name, *args, &block)
          set_persistence_options(@target, @options)
          @target.send(name, *args, &block)
        ensure
          set_persistence_options(@target, nil)
         end

        def send(symbol, *args)
          __send__(symbol, *args)
        end

        def self.const_missing(name)
          ::Object.const_get(name)
        end
      end
      
    end
  end
end