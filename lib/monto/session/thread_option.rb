# encoding: utf-8
module Monto
  module Session
    module ThreadOption
      extend Concernable

      module ClassMethods

        def session_name
          Threaded.session_override || super
        end

        def database_name
          Threaded.database_override || super
        end
      end
    end
  end
end
