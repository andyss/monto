# encoding: utf-8
module Monto
  module Session
    module StorageOption
      extend Concernable

      included do      
        cattr_accessor :storage_options, instance_writer: false do
          storage_options_defaults
        end
      end

      module ClassMethods

        def store_in(options)
          Validators::Storage.validate(self, options)
          storage_options.merge!(options)
        end

        def reset_storage_options!
          self.storage_options = storage_options_defaults.dup
        end

        def storage_options_defaults
          {
            collection: name.to_sym,
            session: :default,
            database: -> { Monto.sessions[session_name][:database] }
          }
        end

        def collection_name
          __evaluate__(storage_options[:collection])
        end

        def session_name
          __evaluate__(storage_options[:session])
        end

        def database_name
          __evaluate__(storage_options[:database])
        end

        private

        def __evaluate__(name)
          return nil unless name
          name.respond_to?(:call) ? name.call.to_sym : name.to_sym
        end
      end
    end
  end
end
